class MessagesController < ApplicationController
  before_action :logged_in_account
  
  def inbox
  end

  def sent
  end

  def spam
  end

  def trash
  end
  
  def create
    @message = current_account.messages.build(message_params)
    if @message.save
      flash[:success] = "Message sent!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end
  
  private

    def message_params
      params.require(:micropost).permit(:content)
    end
    
end
