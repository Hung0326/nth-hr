# frozen_string_literal: true

# User controller
class UsersController < ApplicationController
  before_action :authenticate_user!, only: :my_page
  def confirm_sign_up
    render :confirm
  end

  def my_page; end

  def set_lang
    if user_signed_in? && current_user.language != params[:lang]
      User.update(current_user.id, language: params[:lang]) if params[:lang] == 'vi' || params[:lang] == 'en'
    end
    redirect_to '/'
  end
end
