# frozen_string_literal: true

# Home page
class HomeController < ApplicationController
  def index
    @industries = Industry.order(name: :asc).all
    @job_count = Job.count
    @cities = City.all_cities
    @lasted_jobs = Job.order(created_at: :desc).limit(Job::NUMBER_LASTED_JOB)
    @top_cities = City.top_cities(9)
    @top_industries = Industry.top_industries(9)
  end
end
