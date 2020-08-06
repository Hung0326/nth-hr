# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  get 'industries', to: 'industry#index', as: :industry_index
  get 'cities', to: 'city#index', as: :city_index

  # Search
  get 'jobs/:model/:slug', to: 'job#index', as: :jobs

  # Rails error
  match '/404', to: 'error#page_not_found', via: :all
  match '/500', to: 'error#internal_server_error', via: :all
end
