# frozen_string_literal: true

class ApplyJobController < ApplicationController
  before_action :authenticate_user!, only: :apply

  def apply
    redirect_to root_path if params[:job_id].blank?
    @data_apply = AppliedJob.new    
    session[:job_id] = params[:job_id]
  end

  def catch_data(applied_job_params)
    @apply_job = AppliedJob.new(applied_job_params)
    if @apply_job.cv.blank?
      if current_user.cv.present?
        @apply_job.cv = current_user.cv
        render :confirm
      else
        flash[:error] = t('pages.mypage.nofile')
        redirect_to apply_path(job_id: session[:job_id])
        session.delete(:job_id)
      end
    end
    @apply_job
  end

  def confirm
    @apply_job ||= catch_data(applied_job_params)
  end

  def show
  end

  def save    
    debugger
    confirm.save
  end

  private

  def applied_job_params
    params.require(:applied_job).permit(:user_id, :job_id, :name, :email, :cv)
  end
end
