# frozen_string_literal: true

class FavoriteController < ApplicationController
  before_action :authenticate_user!

  def discard_flash
    flash.discard
  end

  def index
    @list_favorited = current_user.favorites.all
  end

  def check_user_signin
    flash[:error] = t('devise.failure.unauthenticated')
    redirect_to new_user_session_path unless user_signed_in?
  end

  def create
    return redirect_to root_path if Job.find(params[:job_id]).blank?
    
    @favorite = current_user.favorites.new(job_id: params[:job_id])
    respond_to :js if @favorite.save
  end
  
  def destroy
    @favorite = current_user.favorites.find_by(id: params[:favorite_id])
    return redirect_to root_path if @favorite.blank?
    respond_to :js if @favorite.destroy
  end
end
