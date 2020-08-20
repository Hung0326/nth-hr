# frozen_string_literal: true

class FavoriteController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorites = current_user.favorites.map(&:job)
  end

  def create
    return redirect_to root_path if Job.find(params[:job_id]).blank?

    @favorite = current_user.favorites.new(job_id: params[:job_id])
    if @favorite.invalid?
      helpers.render_errors(@favorite)
      redirect_to root_path
    end
    respond_to :js if @favorite.save
  end

  def destroy
    @favorite = current_user.favorites.find_by(id: params[:favorite_id])
    return redirect_to root_path if @favorite.blank?

    respond_to :js if @favorite.destroy
  end
end
