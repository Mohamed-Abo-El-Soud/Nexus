class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  include SessionsHelper
  
  # modal seems to be present at every page
  # TODO: the modals don't need to be rendered if the user is logged in
  before_action :new_user
  
  
  private
  
  def new_user
    @account = Account.new
  end
  
end
