Rails.application.routes.draw do

  devise_for :users, 
    defaults: { format: :json },
    controllers: {
      sessions: 'users/sessions',
      resgistrations: 'users/resgistrations'
    }, 
    path: '',
    path_names: { 
      sign_in: "login",
      sign_out: "logout",
      sign_up: "register"
    }
end
