# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  get 'industry/index'
  get 'city/index'

  # Search
  get 'jobs/industry/:key_industry', to: 'job#find_jobs_by_industry'
  get 'jobs/company/:key_company', to: 'job#find_jobs_by_company'
  get 'jobs/city/:key_city', to: 'job#find_jobs_by_city'
end
