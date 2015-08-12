class MessagesController < ApplicationController
  before_action :logged_in_account
  
  def inbox
    # @feed_items = current_account.category("read","unread").where("reciever_id = ?", current_account.id).paginate(page: params[:page])
    @feed_items = current_account.category("read","unread").paginate(page: params[:page])
  end

  def sent
    @feed_items = current_account.messages.paginate(page: params[:page])
  end

  def spam
    # @feed_items = current_account.category("spam").where("reciever_id = ?", current_account.id).paginate(page: params[:page])
    @feed_items = current_account.category("spam").paginate(page: params[:page])
  end

  def trash
    # @feed_items = current_account.category("trash").where("reciever_id = ?", current_account.id).paginate(page: params[:page])
    @feed_items = current_account.category("trash").paginate(page: params[:page])
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
  
  def make_unread
    message = Message.find(params[:id])
    message.category = "read"
    if message.save
      render text: "OK"
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
    
    
end
