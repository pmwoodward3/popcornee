Rails.application.routes.draw do
    get "/:page" => "static#show"
    resources :movies, :path => ''
    root "movies#index"
end