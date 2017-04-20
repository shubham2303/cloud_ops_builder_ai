Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get '/', to: 'admin/dashboard#index'
  get '/admin/bulk', to: 'admin/agents#bulk'
  post '/admin/agents/bulk_creation'
  # post 'admin/reports', to: 'admin/dashboard#generate_reports'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, format: false, defaults: {format: :json} do
    match 'v2/individuals/',           to: 'v1/individuals#get_individuals',    via: :get, format: false, defaults: {format: :json}
    namespace :v1 do

      match '/agents/me',           to: 'agents#update_me',    via: :put, format: false, defaults: {format: :json}
      match '/individuals/:uuid/vehicles', to: 'vehicles#create', via: :post, format: false, defaults: {format: :json}
      match '/vehicles', to: 'vehicles#create_alone', via: :post, format: false, defaults: {format: :json}
      match '/individuals/vehicle', to: 'vehicles#vehicle', via: :post, format: false, defaults: {format: :json}
      match '/individuals/',           to: 'individuals#get_individuals',    via: :get, format: false, defaults: {format: :json}
      match '/offline/down_sync',             to: 'offline#down_sync', via: :get, format: false, defaults: {format: :json}
      match '/offline/dump',             to: 'offline#dump', via: :get, format: false, defaults: {format: :json}
      resources :otp, only: []  do
        collection do
          get :generate_otp
          post :verify
        end  
      end
      resources :agents
      resources :businesses, only: [:create]
      resources :individuals do
        resources :businesses, only: [:create]
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
