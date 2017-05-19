Rails.application.routes.draw do

  get '/companies', to: 'companies#index'
  get '/orders/as_customer(/:state)', to: 'orders#index_as_customer' # TODO: 1)
  get '/orders/as_provider(/:state)', to: 'orders#index_as_provider'
  put '/orders/:id', to: 'orders#update'
  post '/orders', to: 'orders#create'
  get '/orders/:id', to: 'orders#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
