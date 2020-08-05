# frozen_string_literal: true

# Job controller
class JobController < ApplicationController
  before_action :load_data_dropdown, only: %i[find_jobs_by_industry find_jobs_by_city find_jobs_by_company]

  def find_jobs_by_city
    city = City.find(params[:key_city])
    result(city)
  end

  def find_jobs_by_industry
    industry = Industry.find(params[:key_industry])
    result(industry)
  end

  def find_jobs_by_company
    company = Company.find(params[:key_company])
    result(company)
  end

  def find_jobs
    d = params[:model].capitalize
    obj = .find(params[:id])
    result(obj)
  end

  private

  def load_data_dropdown
    @industries = Industry.order(name: :asc).all
    @cities = City.select(:id, :name)
  end

  def result(obj)
    @keyword = obj.name
    @data = obj.jobs.page(params[:page])
    render 'result_data'
  end
end
