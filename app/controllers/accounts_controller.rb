class AccountsController < ApplicationController
  before_action :logged_in_account, only: [:index, :edit, :update, :destroy]
  before_action :correct_account,   only: [:edit, :update]
  before_action :admin_account,     only: :destroy
  before_action :build_message,     only: [:show, :update]
  
  include MessagesHelper
  
  def show
    @account = Account.find(params[:id])
    @messages = @account.involved(current_account).paginate(page: params[:page])
  end
  
  def index
    @accounts = Account.paginate(page: params[:page])
  end
  
  def edit
  end
  
  def create
    @account = Account.new(account_params)
    if @account.save
      @account.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      # log_in @account
      # flash[:success] = "Welcome to the Nexus!"
      # redirect_to @account
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
  
  def destroy
    Account.find(params[:id]).destroy
    flash[:success] = "Account deleted"
    redirect_to accounts_url
  end
  
  private

    def account_params
      params.require(:account).permit(:first_name, :last_name,
                                   :email, :telephone, :password,
                                   :password_confirmation)
    end
    
    def correct_account
      @account = Account.find(params[:id])
      redirect_to(root_url) unless current_account?(@account)
    end
    
    # Confirms an admin account.
    def admin_account
      redirect_to(root_url) unless current_account.admin?
    end
end
