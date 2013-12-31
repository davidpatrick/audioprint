Audioprint::Application.routes.draw do
  resources :blog_posts, path: :blog
  match "/blog/:year", :to => "blog_posts#index", via: :get, :constraints => { :year => /\d{4}/ }
  match "/blog/:year/:month", :to => "blog_posts#index", via: :get, :constraints => { :year => /\d{4}/, :month => /\d{1,2}/ }
  match "/blog/:year/:month/:slug", :to => "blog_posts#show", via: :get, :constraints => { :year => /\d{4}/, :month => /\d{1,2}/, :slug => /[a-z0-9\-]+/ }
  match "/blog/:year/:month/:slug/destroy", :to => "blog_posts#destroy", via: :post, :constraints => { :year => /\d{4}/, :month => /\d{1,2}/, :slug => /[a-z0-9\-]+/ }
  match "/blog/:year/:month/:slug/edit", :to => "blog_posts#edit", via: :get, :constraints => { :year => /\d{4}/, :month => /\d{1,2}/, :slug => /[a-z0-9\-]+/ }
  match "/blog/:year/:month/:slug", :to => "blog_posts#update", via: :put, :as => :update, :constraints => { :year => /\d{4}/, :month => /\d{1,2}/, :slug => /[a-z0-9\-]+/ }

  root :to => "home#index"

  devise_for :users
  resources :users do
    member do
      get :edit_role
      put :change_role
    end
  end
  resources :addresses

  resources :albums, :mix_tapes do
    collection do
      post :sort_tracks
    end

    post :add_songs, :on => :member
  end

  resources :songs do
    member do
      get :ajax_song
    end
  end

  match 'songs/:id/download', :to => 'songs#download', :as => 'download_song', via: :get

  resources :orders do
    member do
      get :checkout
      put :save_address
      post :purchase
      post :review_and_submit

      put :process_order
      patch :ship_order
    end

    collection do
      get :view_cart
    end
  end

  resources :order_items
  resources :charges

  match 'become_contributor', :to => 'users#become_contributor', via: :post
  match 'admin_create', :to => 'users#create', via: :post

  match 'albums/:id/add_to_cart', to: 'order_items#create', as: 'add_album_to_cart', type: 'album', via: :get
  match 'songs/:id/add_to_cart', to: 'order_items#create', as: 'add_song_to_cart', type: 'song', via: :get

  mount Ckeditor::Engine => "/ckeditor"
end
