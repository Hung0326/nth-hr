# frozen_string_literal: true

# Home page
class HomeController < ApplicationController
  def index
    @industries = Industry.order(name: :asc).all
    @job_count = Job.all.count
    @cities = City.all
    @lasted_jobs = Job.order(created_at: :desc).limit(Job::NUMBER_LASTED_JOB)
    @top_cities = City.top_hot.take(9)
    @top_industries = Industry.top_hot.take(9)
  end
end
