# frozen_string_literal: true

Rails.application.routes.draw do
  get 'setting', to: 'users#set_lang', as: :set_lang
  scope '(:locale)', locale: /en|vi/ do
    devise_for :users, controllers: { sessions: 'sessions', registrations: 'registrations' }
    root 'home#index'

    get 'register/:code', to: 'users#confirm_sign_up', as: :confirm_sign_up
    get 'industries', to: 'industry#index', as: :industry_index
    get 'cities', to: 'city#index', as: :city_index
    # Applied job
    get 'apply', to: 'apply_job#apply', as: :apply
    post 'confirm', to: 'apply_job#confirm', as: :confirm
    post 'done', to: 'apply_job#done', as: :done
    get 'my/jobs', to: 'apply_job#index', as: :list_applied_jobs
    # Fovorite
    post 'favorite', to: 'favorite#create', as: :favorite
    delete 'favorite', to: 'favorite#destroy', as: :destroy_favorite
    get 'favorite', to: 'favorite#index', as: :favorite_index
    # Details job
    get 'detail/:id', to: 'job#detail', as: :detail_job
    # Search
    get 'jobs/:model/:slug', to: 'job#index', as: :jobs
    # My page
    get 'my', to: 'users#my_page', as: :my_page
    # Rails error
    match '/404', to: 'error#page_not_found', via: :all
    match '/500', to: 'error#internal_server_error', via: :all
  end
end
