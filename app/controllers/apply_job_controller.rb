# frozen_string_literal: true

# Applied jobs controller
class ApplyJobController < ApplicationController
  before_action :authenticate_user!, only: :apply

  def index
    @jobs = current_user.applied_jobs.page(params[:page])
  end

  def apply
    redirect_to root_path if params[:job_id].blank?
    @data_apply = current_user.applied_jobs.new(name: current_user.name, email: current_user.email)
    session[:job_id] = params[:job_id]
    @job = Job.find(params[:job_id])
  end

  def confirm
    @apply_job = current_user.applied_jobs.new(applied_job_params)
    @apply_job.cv = current_user.cv if @apply_job.cv.blank?
    session[:cv_full_path] = @apply_job.cv.path
    if @apply_job.invalid?
      errors = []
      @apply_job.errors.full_messages.each { |mess| errors << "#{mess}<br>" }
      flash[:error] = errors.join('<br>').html_safe
      redirect_to apply_path(job_id: session[:job_id])
      session.delete(:job_id)
    end
  end

  def done
    data_apply = current_user.applied_jobs.new(applied_job_params)
    data_apply.cv = File.new(session[:cv_full_path])
    if data_apply.save
      AppliedMailer.applied_job_mail_to(current_user.applied_jobs.last).deliver_now
      render :done
    else
      flash[:error] = t('apply_job.error')
      redirect_to apply_path(job_id: applied_job_params[:job_id])
    end
    session.delete(:cv_full_path)
  end

  private

  def applied_job_params
    params.require(:applied_job).permit(:job_id, :name, :email, :cv)
  end
end
