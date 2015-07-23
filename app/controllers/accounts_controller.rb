class AccountsController < ApplicationController
  
  def new
  end
  
  def show
    @account = Account.find(params[:id])
  end
  
  def create
    @sign_up_attempt = false
    @account = Account.new(account_params)
    if @account.save
      log_in @account
      @sign_up_attempt = true
      flash[:success] = "Welcome to the Nexus!"
      redirect_to @account
    else
      # save not successful, show errors
      flash[:open_modal] = "#sign-up"
      render '/static_pages/home'
    end
  end
  
  def update
    @account_edit_attempt = true
    @account = Account.find(params[:id])
    if @account.update_attributes(account_params)
      @account_edit_attempt = true
      raise
      # Handle a successful update.
    else
      flash[:danger] = "Account not updated!"
      flash[:open_modal] = "#settings"
      render 'show'
    end
  end
  
  private

    def account_params
      params.require(:account).permit(:first_name, :last_name,
                                   :email, :telephone, :password,
                                   :password_confirmation)
    end
  
end
