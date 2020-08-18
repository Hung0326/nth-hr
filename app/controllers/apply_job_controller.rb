# frozen_string_literal: true

# Applied jobs controller
class ApplyJobController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = current_user.applied_jobs.order(created_at: :desc).page(params[:page])
  end

  def apply
    redirect_to root_path if params[:job_id].blank?
    @data_apply = current_user.applied_jobs.new(name: current_user.name, email: current_user.email)
    session[:job_id] = params[:job_id]
    @job = Job.find(params[:job_id])
  end

  def confirm
    @apply_job = current_user.applied_jobs.new(applied_job_params)
    @apply_job.job_id = session[:job_id]
    @apply_job.cv = current_user.cv if @apply_job.cv.blank?
    session[:cache_name] = @apply_job.cv.cache_name
    if @apply_job.invalid?
      errors = []
      @apply_job.errors.full_messages.each { |mess| errors << "#{mess}<br>" }
      flash[:error] = errors.join('<br>').html_safe
      redirect_to apply_path(job_id: session[:job_id])
    end
  end

  def done
    apply_data = current_user.applied_jobs.new(applied_job_params)
    apply_data.job_id = session[:job_id]
    apply_data.cv.retrieve_from_cache!(session[:cache_name])
    if apply_data.save
      AppliedMailer.applied_job_mail_to(apply_data).deliver_now
      render :done
    else
      flash[:error] = t('apply_job.error')
      redirect_to apply_path(job_id: applied_job_params[:job_id])
    end
    session.delete(:job_id)
    session.delete(:cache_name)
  end

  private

  def applied_job_params
    params.require(:applied_job).permit(:name, :email, :cv)
  end
end
