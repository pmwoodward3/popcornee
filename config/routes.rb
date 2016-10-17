Rails.application.routes.draw do
    match '*path' => redirect('/')   unless Rails.env.development?
    get "static/:p" => "static#show"
    resources :movies, :path => ''
    root "movies#index"
end