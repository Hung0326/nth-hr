# frozen_string_literal: true

class ApplyJobController < ApplicationController
  before_action :authenticate_user!, only: :apply
  def apply    
    @data_apply = AppliedJob.new
    session[:job_id] = params[:job_id]
  end

  def confirmation    
    @data_apply = AppliedJob.new(applied_job_params)
    if @data_apply.save
      session[:user_name] = @data_apply.name
      session[:user_email] = @data_apply.email
      redirect_to show_path
    else
      flash[:error] = 'error'
      render 'apply'
    end
  end

  def show
  end

  def save    
    @data_apply.save
  end

  private

  def applied_job_params
    params.require(:applied_job).permit(:user_id, :job_id, :name, :email, :cv)
  end
end
