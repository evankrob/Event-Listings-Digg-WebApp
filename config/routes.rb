Wur::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :events, :only => [:index, :new, :create] do
    resources :occurrences, :only => :create
  end
  resources :specials, :only => :index
  resources :food_specials, :only => :index
  resources :drink_specials, :only => :index
  resources :tags, :only => :index
  match 'textile/preview' => 'textile#preview'

  match 'tags/:tag' => 'tags#show', :as => :tag

  match 'categories/:name' => 'categories#show', :as => :category

  match 'search' => 'search#new', :as => :search
  match 'search/results' => 'search#show', :as => :search_results
  match 'search/quick' => 'search#quick', :as => :quick_search

  match 'subscribe' => 'subscriptions#new', :as => :new_subscription
  resources :subscriptions, :only => [:create, :show, :destroy]

  match ':other/events' => 'events#other', :as => 'other_events'
  match ':other/specials' => 'specials#other', :as => 'other_specials'
  match ':other/food_specials' => 'food_specials#other', :as => 'other_food_specials'
  match ':other/drink_specials' => 'drink_specials#other', :as => 'other_drink_specials'

  match ':city/events' => 'events#index', :as => 'city_events'
  match ':city/specials' => 'specials#index', :as => 'city_specials'
  match ':city/food_specials' => 'food_specials#index', :as => 'city_food_specials'
  match ':city/drink_specials' => 'drink_specials#index', :as => 'city_drink_specials'

  match ':city/:venue/events/:id' => 'events#show', :as => 'venue_event'
  match ':city/:venue/events' => 'venues#events', :as => 'venue_events'
  match ':city/:venue/specials/:id' => 'specials#show', :as => 'venue_special'
  match ':city/:venue/specials' => 'venues#specials', :as => 'venue_specials'
  match ':city/:venue' => 'venues#show', :as => 'venue'

  %w(about contact).each { |action| match action => "home##{action}" }

  match 'today' => 'home#today', :as => 'today'
  match 'weekend' => 'home#weekend', :as => 'this_weekend'
  match 'other' => 'home#other', :as => :other_cities
  match ':city' => 'home#city', :as => :city

  root :to => 'events#index'
end
