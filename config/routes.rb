Rails.application.routes.draw do

  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }

  namespace :api do
    namespace :v1 do
      resources :products
      
      post '/deposit' => 'vending#deposit'
      post '/buy' => 'vending#buy'
      post '/reset' => 'vending#reset'
    end
  end
  

end
