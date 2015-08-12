class StaticPagesController < ApplicationController
  before_action :build_message,     only: :home
  # before_action :new_user
  
  def home
  end

  def about
    
  end

  def contact
  end

  def help
  end
  
end
