# frozen_string_literal: true

# User controller
class UsersController < ApplicationController
  before_action :authenticate_user!, only: :my_page
  def confirm_sign_up
    render :confirm
  end

  def my_page
  end
end
