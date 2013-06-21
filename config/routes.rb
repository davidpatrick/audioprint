Audioprint::Application.routes.draw do
  resources :products

  resources :blog_posts, path: :blog

  match "/blog/:year", :to => "blog_posts#index", :constraints => { :year => /\d{4}/ }
  match "/blog/:year/:month", :to => "blog_posts#index", :constraints => { :year => /\d{4}/, :month => /\d{1,2}/ }
  match "/blog/:year/:month/:slug", :to => "blog_posts#show", :as => :post, :constraints => { :year => /\d{4}/, :month => /\d{1,2}/, :slug => /[a-z0-9\-]+/ }

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#landing"

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

  resources :songs do
    get :new_from_modal, :on => :collection
  end

  match 'songs/:id/download', :to => 'songs#download', :as => 'download_song'


  mount Ckeditor::Engine => "/ckeditor"
end
