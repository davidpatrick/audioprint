Audioprint::Application.routes.draw do
  resources :addresses


  resources :blog_posts, path: :blog

  match "/blog/:year", :to => "blog_posts#index", :constraints => { :year => /\d{4}/ }
  match "/blog/:year/:month", :to => "blog_posts#index", :constraints => { :year => /\d{4}/, :month => /\d{1,2}/ }
  match "/blog/:year/:month/:slug", :to => "blog_posts#show", :via => :get, :constraints => { :year => /\d{4}/, :month => /\d{1,2}/, :slug => /[a-z0-9\-]+/ }
  match "/blog/:year/:month/:slug/edit", :to => "blog_posts#edit", :constraints => { :year => /\d{4}/, :month => /\d{1,2}/, :slug => /[a-z0-9\-]+/ }
  match "/blog/:year/:month/:slug", :to => "blog_posts#update", :via => :put, :as => :update, :constraints => { :year => /\d{4}/, :month => /\d{1,2}/, :slug => /[a-z0-9\-]+/ }

  # authenticated :user do
  #   root :to => 'home#index'
  # end
  root :to => "home#index"

  devise_for :users
  resources :users
  match 'become_contributor', :to => 'users#become_contributor'

  resources :albums do
    collection do
      post :sort_tracks
      get :ajax_uploaded_song
    end
    post :add_songs, :on => :member
  end

  resources :songs
  match 'songs/:id/download', :to => 'songs#download', :as => 'download_song'

  resources :orders do
    member do
      put :purchase
      put :process_order
      post :ship_order
    end
    collection do
      get :view_cart
    end
  end

  resources :order_items
  match 'albums/:id/add_to_cart', to: 'order_items#create', as: 'add_album_to_cart', type: 'album'
  match 'songs/:id/add_to_cart', to: 'order_items#create', as: 'add_song_to_cart', type: 'song'
  mount Ckeditor::Engine => "/ckeditor"
end
