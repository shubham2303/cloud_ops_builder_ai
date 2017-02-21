Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, format: false, defaults: {format: :json} do
    namespace :v1 do

      match '/agents/me',           to: 'agents#update_me',    via: :put, format: false, defaults: {format: :json}
      match '/individuals/:pid/businesses', to: 'businesses#create', via: :post, format: false, defaults: {format: :json}
      match '/businesses', to: 'businesses#create', via: :post, format: false, defaults: {format: :json}
      resources :otp  do
        get :generate_otp, on: :collection
        post :verify, on: :collection
      end
      resources :individuals
    end
  end

end
