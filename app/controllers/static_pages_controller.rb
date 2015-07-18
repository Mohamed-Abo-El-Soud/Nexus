class StaticPagesController < ApplicationController
  before_action :new_user
  
  def home
  end

  def about
  end

  def contact
  end

  def help
  end
  
  private
  
  def new_user
    @account = Account.new
  end
  
end
