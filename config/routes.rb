Rails.application.routes.draw do
  namespace :api do
    get '/all' => 'airfares#index'
    get '/skyscanner' => 'airfares#skyscanner'
    get '/airfares' => 'airfares#airfare'
    get '/createskyscanner' => 'airfares#create_skyscanner'
  end

end
