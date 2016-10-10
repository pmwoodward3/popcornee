Rails.application.routes.draw do
    resources :yts
    root "yts#index"
end
