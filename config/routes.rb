Rails.application.routes.draw do
    get "static/:p" => "static#show"
    resources :movies, :path => ''
    root "movies#index"
end