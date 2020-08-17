# frozen_string_literal: true

# User controller
class UsersController < ApplicationController
  before_action :authenticate_user!, only: :my_page
  def confirm_sign_up
    render :confirm
  end

  def my_page
  end

  def set_lang 
    if user_signed_in?     
      if params[:lang] == 'vi' || params[:lang] == 'en'       
        User.update(current_user.id, language: params[:lang]) 
        redirect_to '/' 
      else 
        redirect_to '/' 
      end   
    end
  end
end
