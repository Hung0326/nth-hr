# frozen_string_literal: true

# Job controller
class JobController < ApplicationController
  before_action :load_data_dropdown, only: :index
  after_action :add_job_to_history, only: :detail
  def add_job_to_history
    current_user.histories.find_or_create_by(job_id: session[:params_job_id]) if user_signed_in?
    counter_history = current_user.histories.count
    current_user.histories.destroy(current_user.histories.first) if counter_history > 20
    session.delete(:params_job_id)
  end

  def index
    model = params[:model].classify.constantize
    obj = model.find_by(slug: params[:slug])
    render_result(obj)
  end

  def detail
    @job = Job.find(params[:id]).decorate
    session[:params_job_id] = @job.id
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
    return render 'error/page_not_found' if @data.blank?

    render 'result_data'
  end
end
