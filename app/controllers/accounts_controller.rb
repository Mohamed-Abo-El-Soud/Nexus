class AccountsController < ApplicationController
  
  def new
  end
  
  def show
    @account = Account.find(params[:id])
    # debugger
  end
  
  def create
    # debugger
    @account = Account.new(account_params)    # Not the final implementation!
    if @account.save
      # Handle a successful save.
    else
      render 'new'
    end
  end
  
  private

    def account_params
      params.require(:account).permit(:first_name, :last_name,
                                   :email, :telephone, :password,
                                   :password_confirmation)
    end
  
end
