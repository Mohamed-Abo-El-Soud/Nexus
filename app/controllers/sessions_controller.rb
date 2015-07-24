class SessionsController < ApplicationController
  def create
    # the log_in_attempt is an indicator to pop up the modals in /static_pages/home
    account = Account.find_by(email: params[:session][:email].downcase)
    if account && account.authenticate(params[:session][:password])
      log_in account
      params[:session][:remember_me] == '1' ? remember(account) : forget(account)
      redirect_to account
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      # login not successful, show errors
      flash[:open_modal] = "#log-in"
      render '/static_pages/home'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end
