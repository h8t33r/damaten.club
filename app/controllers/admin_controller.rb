class AdminController < ApplicationController
  def show_devise_users
    @users = User.all
  end
end
