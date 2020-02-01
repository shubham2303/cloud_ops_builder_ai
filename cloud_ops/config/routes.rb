Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  resources :view_pricing, only: [:index]

# get '/fetch_pricing_data/', to: 'view_pricing#fetch_pricing_data'

end
