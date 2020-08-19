# frozen_string_literal: true

# User controller
class UsersController < ApplicationController
  before_action :authenticate_user!, only: :my_page
  def confirm_sign_up
    render :confirm
  end

  def my_page; end

  def set_lang
    current_user.update_current_language(params[:lang]) if user_signed_in?
    redirect_to '/'
  end
end
