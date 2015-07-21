class AccountsController < ApplicationController
  
  def new
  end
  
  def show
    @account = Account.find(params[:id])
    # debugger
  end
  
  def create
    # debugger
    @account = Account.new(account_params)
    if @account.save
      # Handle a successful save.
    else
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
