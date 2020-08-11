# frozen_string_literal: true

# User controller
class UsersController < ApplicationController
  def confirm_sign_up
    render :confirm
  end

  def my_page
    if user_signed_in?
      render :my_page
    else
      redirect_to root_path
    end
  end
end
