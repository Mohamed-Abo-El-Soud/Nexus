class SessionsController < ApplicationController
  def create
    # the log_in_attempt is an indicator to pop up the modals in /static_pages/home
    @log_in_attempt = false
    account = Account.find_by(email: params[:session][:email].downcase)
    if account && account.authenticate(params[:session][:password])
      @log_in_attempt = true
      # Log the account in and redirect to the account's show page.
      log_in account
      redirect_to account
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      # login not successful, show errors
      render '/static_pages/home'
    end
  end
end
