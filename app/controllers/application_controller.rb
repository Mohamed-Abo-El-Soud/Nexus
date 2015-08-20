class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  include SessionsHelper
  
  # modal seems to be present at every page
  # TODO: the modals don't need to be rendered if the user is logged in
  before_action :check_if_account_present
  
  
  private
  
    def check_if_account_present
      unless logged_in?
        @account ||= Account.new
      end
    end
  
    def logged_in_account
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        flash[:open_modal] = "#log-in"
        redirect_to root_url
      end
    end
  
    def build_message
      if logged_in?
        @feed_items = feed_chooser "inbox"
        @message = current_account.messages.build
      end
    end
    
    def feed_chooser(type, other_account = nil)
      case type
        when "inbox"
          current_account.category("read","unread").paginate(page: params[:page])
        when "sent"
          current_account.messages.paginate(page: params[:page])
        when "spam"
          current_account.category("spam").paginate(page: params[:page])
        when "trash"
          current_account.category("trash").paginate(page: params[:page])
        when "other"
          other_account.involved(current_account).paginate(page: params[:page])
        else raise
      end
    end
end
