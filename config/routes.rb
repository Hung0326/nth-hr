Rails.application.routes.draw do

  root 'home#index'
  get 'industry/index'
  get 'city/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
