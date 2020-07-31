# frozen_string_literal: true

# Home page
class HomeController < ApplicationController
  def index
    @industries = Industry.order(name: :asc).all
    @job_count = Job.all.count
    @cities = City.all
    @five_jobs = Job.order(created_at: :desc).limit(5)
    @top_city = City.top_hot.take(9)
    @top_industry = Industry.top_hot.take(9)
  end
end
