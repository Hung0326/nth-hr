# frozen_string_literal: true

Rails.application.routes.draw do
  get 'setting', to: 'users#set_lang', as: :set_lang
  scope '(:locale)', locale: /en|vi/ do
    devise_for :users, controllers: { registrations: 'registrations', passwords: 'passwords'}
    root 'home#index'
    get 'search', to: 'search#multi_search', as: :search
    get 'register/:code', to: 'users#confirm_sign_up', as: :confirm_sign_up
    get 'industries', to: 'industry#index', as: :industry_index
    get 'cities', to: 'city#index', as: :city_index
    # Applied job
    get 'apply', to: 'apply_job#apply', as: :apply
    post 'confirm', to: 'apply_job#confirm', as: :confirm
    post 'done', to: 'apply_job#done', as: :done
    get 'my/jobs', to: 'apply_job#index', as: :list_applied_jobs
    # Fovorite
    resources :favorite, only: %i[index create destroy]
    # History
    get 'history', to:'histories#index', as: :list_histories
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
