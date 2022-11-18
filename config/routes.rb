Rails.application.routes.draw do

  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      resgistrations: 'users/resgistrations'
    }

  namespace :api do
    namespace :v1 do
      resources :products

    end
  end
  
  post '/deposit' => 'vending#deposit'
  post '/buy' => 'vending#buy'
  post '/reset' => 'vending#reset'

end
