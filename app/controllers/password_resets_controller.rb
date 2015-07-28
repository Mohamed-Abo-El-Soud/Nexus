class PasswordResetsController < ApplicationController
  before_action :get_account,   only: [:edit, :update]
  before_action :valid_account, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

  def edit
  end
  
  def create
    account = Account.find_by(email: params[:password_reset][:email].downcase)
    if account
      account.create_reset_digest
      account.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      # raise
      render 'new'
    end
  end
  
  def update
    if params[:account][:password].empty?
      flash.now[:danger] = "Password can't be empty"
      render 'edit'
    elsif @account.update_attributes(account_params)
      log_in @account
      flash[:success] = "Password has been reset."
      redirect_to @account
    else
      render 'edit'
    end
  end
  
  private  

    def account_params
      params.require(:account).permit(:password, :password_confirmation)
    end
    
    def get_account
      @account = Account.find_by(email: params[:email])
    end

    # Confirms a valid account.
    def valid_account
      unless (@account && @account.activated? &&
              @account.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # Checks expiration of reset token.
    def check_expiration
      if @account.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
    
end
