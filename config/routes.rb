Rails.application.routes.draw do

  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      resgistrations: 'users/resgistrations'
    }

  namespace :api do
    namespace :v1 do
      resources :products

      # post "deposit", to: ""
    end
  end

end
