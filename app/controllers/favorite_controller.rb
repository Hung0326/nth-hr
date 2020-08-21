# frozen_string_literal: true

class FavoriteController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorites = current_user.favorites.order(created_at: :desc).map(&:job)
  end

  def create
    return redirect_to root_path if Job.find(params[:job_id]).blank?

    @favorite = current_user.favorites.new(job_id: params[:job_id])
    if @favorite.invalid?
      helpers.render_errors(@favorite)
      return redirect_to favorite_index_path
    end
    respond_to :js if @favorite.save
  end

  def destroy
    @favorite = current_user.favorites.find_by(id: params[:id])
    return redirect_to favorite_index_path if @favorite.blank?

    respond_to :js if @favorite.destroy
  end
end
