# frozen_string_literal: true

# Job controller
class JobController < ApplicationController
  before_action :load_data_dropdown, only: :index
  # after_action :add_job_to_history, only: :detail

  def add_job_to_history
    current_user.histories.create(session[:params_job_id]) if user_signed_in?
    session.delete(:params_job_id)
  end

  def index
    model = params[:model].classify.constantize
    obj = model.find_by(slug: params[:slug])
    render_result(obj)
  end

  def detail
    session[:params_job_id] = params[:id]
    @job = Job.find(params[:id]).decorate
    cities = @job.cities.first
    industries = @job.industries.first
    add_breadcrumb t('controller.job.detail.home'), root_path
    add_breadcrumb cities.name, jobs_path(model: 'city', slug: cities.slug)
    add_breadcrumb industries.name, jobs_path(model: 'industry', slug: industries.slug)
    add_breadcrumb @job.name
  end

  def load_data_dropdown
    @industries = Industry.order(name: :asc).all
    @cities = City.select(:id, :name)
  end

  def render_result(obj)
    @keyword = obj.name
    @data = obj.jobs.page(params[:page])
    render 'result_data'
  end
end
