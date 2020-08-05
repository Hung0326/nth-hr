# frozen_string_literal: true

# Job controller
class JobController < ApplicationController
  before_action :load_data_dropdown, only: :index

  def index
    model = params[:model].classify.constantize
    obj = model.find_by(slug: params[:slug])
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
Object.const_get('cities'.classify)