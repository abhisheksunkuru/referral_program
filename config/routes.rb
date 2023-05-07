Rails.application.routes.draw do
  devise_for :users

  post 'users/invite'
  get '/users/resend_invitation'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#home"
end
