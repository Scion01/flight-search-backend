Rails.application.routes.draw do
  resources :cities
  resources :flights
  resources :airplanes
  resources :airlines
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
