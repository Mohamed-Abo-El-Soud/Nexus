module SessionsHelper
  # Logs in the given account.
  def log_in(account)
    session[:account_id] = account.id
  end
  
  # Remembers an account in a persistent session.
  def remember(account)
    account.remember
    cookies.permanent.signed[:account_id] = account.id
    cookies.permanent[:remember_token] = account.remember_token
  end
  
  # Returns the current logged-in account (if any).
  def current_account
    if (account_id = session[:account_id])
      @current_account ||= Account.find_by(id: account_id)
    elsif (account_id = cookies.signed[:account_id])
      account = Account.find_by(id: account_id)
      if account && account.authenticated?(cookies[:remember_token])
        log_in account
        @current_account = account
      end
    end
  end
  
  # Returns true if the account is logged in, false otherwise.
  def logged_in?
    !current_account.nil?
  end
  
  # Forgets a persistent session.
  def forget(account)
    account.forget
    cookies.delete(:account_id)
    cookies.delete(:remember_token)
  end
  
  # Logs out the current account.
  def log_out
    forget(current_account)
    session.delete(:account_id)
    @current_account = nil
  end
  
end
