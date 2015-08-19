class MessagesController < ApplicationController
  before_action :logged_in_account
  
  def inbox
    @feed_items = feed_chooser "inbox"
  end

  def sent
    @feed_items = feed_chooser "sent"
  end

  def spam
    @feed_items = feed_chooser "spam"
  end

  def trash
    @feed_items = feed_chooser "trash"
  end
  
  def search
    # stuff...
    type = params[:type]
    other_account = params[:other_account]
    key_terms = params[:key_terms]
    query = feed_chooser type
    feed_items = search_for key_terms, query
    render feed_items
  end
  
  def create
    # debugger
    @message = current_account.messages.build(message_params)
    @message.category = "unread"
    if @message.save
      flash[:success] = "Message sent!"
      # redirect_to request.referer
      redirect_back_or request.referer
      # redirect_to root_url
    else
      # save not successful, show errors
      flash[:open_modal] = "#new-message"
      # store the url that the client was on
      store_referrer
      # we don't need to show a feed right now
      @feed_items = nil
      # render store_and_redirect
      # render :nothing => true
      # render Rails.application.routes.recognize_path(request.referer)[:action]
      # render Rails.application.routes.recognize_path URI(request.referer).path
      # render {:controller=>"accounts", :action=>"show", :id=>"3"}
      # redirect_to request.url if request.get?
      # debugger
      # render_to_string '/static_pages/home'
      render '/static_pages/home'
      flash.delete("open_modal")
    end
  end
  
  
  def move_category
    message = Message.find(params[:id])
    category = params[:category]
    message.category = category
    if message.save
      render text: "sent"
    end
    # message = Message.find(params[:id])
    # render html: "<b>I'm very bold!</b>".html_safe 
    # render text: "sent"
    # render json: { category: "spinach" }
    # render json: "JSON.parse(\"{ category: \"spinach\"}\")"
  end
  
  private

    def message_params
      # params.require(:message).permit(:title, :sender_id, :reciever_id, :content)
      result = params.require(:message).permit(:title, :content)
      reciever = Account.where(email: params[:message][:reciever]).first#.id
      sender = Account.where(email: params[:message][:sender]).first#.id
      result.merge! reciever_id: reciever.id if reciever
      result.merge! sender_id: sender.id if sender
      # result.merge reciever_id: reciever.id, sender_id: sender.id
    end
    
    def store_and_redirect
      controller = Rails.application.routes.recognize_path(request.referer)[:controller]
      controller = "/#{controller}"
      action = Rails.application.routes.recognize_path(request.referer)[:action]
      action = "/#{action}"
      id = Rails.application.routes.recognize_path(request.referer)[:id]
      
      page = Rails.application.routes.recognize_path(request.referer)[:page]
      
      @account = Account.find(id) unless id.nil?
      @messages = @account.messages.paginate(page: page) unless page.nil?
      
      "#{controller}#{action}"
    end
    
    
    def search_for(search,query)
      # preparation_query = "SELECT Accounts.first_name, Accounts.last_name, Messages.title, Messages.content 
      #                       FROM Messages JOIN Accounts ON Messages.sender_id = Accounts.id"
      
      query ||= Message.joins("JOIN Accounts ON Messages.sender_id = Accounts.id")
      query.where("Messages.title LIKE ? or
                  Messages.content LIKE ? or
                  Accounts.first_name LIKE ? or
                  Accounts.last_name LIKE ?",
                  "%#{search}%",
                  "%#{search}%",
                  "%#{search}%",
                  "%#{search}%")
      
      # this is how a merge is done
      # name_relation = first_name_relation.merge(last_name_relation)
      
    end
end
