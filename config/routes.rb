Rails.application.routes.draw do
  namespace :api do
    post '/urls', to: 'urls#create'
    get '/urls/:short_url', to: 'urls#show', as: :short
    get '/urls/:short_url/stats', to: 'urls#stats', as: :stats
  end
end
