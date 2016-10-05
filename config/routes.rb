Rails.application.routes.draw do
    resources :yts
    root "yts#extractor"
end
