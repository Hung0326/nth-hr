# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  get 'industry/index'
  get 'city/index'

  # Search
  get 'jobs/:model/:slug', to: 'job#index', as: :jobs
end
