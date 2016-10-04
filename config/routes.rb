Rails.application.routes.draw do
    resources :omdb
    root "omdb#index"
end
