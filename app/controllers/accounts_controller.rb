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
      @sign_up_attempt = true
      flash[:success] = "Welcome to the Nexus!"
      redirect_to @account
    else
      # save not successful, show errors
      render '/static_pages/home'
    end
  end
  
  private

    def account_params
      params.require(:account).permit(:first_name, :last_name,
                                   :email, :telephone, :password,
                                   :password_confirmation)
    end
  
end
