# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  get 'industries', to: 'industry#index', as: :industry_index
  get 'cities', to: 'city#index', as: :city_index

  # Search
  get 'jobs/:model/:slug', to: 'job#index', as: :jobs
end
