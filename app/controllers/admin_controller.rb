class AdminController < ApplicationController
  def show_devise_users
    @users = User.all
  end

  def link_user_to_player
    
  end

  def imports
    
  end
end
