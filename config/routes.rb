Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, format: false, defaults: {format: :json} do
    namespace :v1 do

      match '/agents/me',           to: 'agents#update_me',    via: :put, format: false, defaults: {format: :json}
      match '/individuals/:uuid/businesses', to: 'businesses#create', via: :post, format: false, defaults: {format: :json}

      resources :otp, only: []  do
        collection do
          get :generate_otp
          post :verify
        end  
      end

      resources :individuals do
        collection do
          post :business
        end
      end
      resources :collections do
        collection do
          post :test_decryption
        end  
      end

    end
  end

end
