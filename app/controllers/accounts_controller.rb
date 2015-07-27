class AccountsController < ApplicationController
  before_action :logged_in_account, only: [:index, :edit, :update]
  before_action :correct_account,   only: [:edit, :update]
  
  def show
    # debugger
    @account = Account.find(params[:id])
  end
  
  def index
    @accounts = Account.all
  end
  
  def edit
  end
  
  def create
    @account = Account.new(account_params)
    if @account.save
      log_in @account
      flash[:success] = "Welcome to the Nexus!"
      redirect_to @account
    else
      # save not successful, show errors
      flash[:open_modal] = "#sign-up"
      render '/static_pages/home'
      flash.delete("open_modal")
    end
  end
  
  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(account_params)
      flash[:success] = "Profile updated"
      redirect_to @account
    else
      flash[:danger] = "Account not updated!"
      flash[:open_modal] = "#settings"
      render 'show'
      flash.delete("open_modal")
      flash.delete("danger")
    end
  end
  
  private

    def account_params
      params.require(:account).permit(:first_name, :last_name,
                                   :email, :telephone, :password,
                                   :password_confirmation)
    end
    
    def logged_in_account
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        flash[:open_modal] = "#log-in"
        redirect_to root_url
      end
    end
    
    def correct_account
      @account = Account.find(params[:id])
      redirect_to(root_url) unless current_account?(@account)
    end
end
