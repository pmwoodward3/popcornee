Rails.application.routes.draw do
    resources :movies, :path => ''
    root "movies#index"
end