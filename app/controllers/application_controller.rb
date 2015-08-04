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
      @message = current_account.messages.build if logged_in?
    end
end
