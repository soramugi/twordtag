Twordtag::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with 'rake routes'.
  root to: 'tops#index'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signout' => 'sessions#destroy'

  match '/analysis' => 'tops#analysis', via: [:get, :post]

  get '/tags' => 'tags#index'
  get '/tags/:word' => 'tags#show', as: 'tag'

  get 'user/:name' => 'users#show', as: 'user'
  get 'user/:name/search/:word' => 'users#search', as: 'search_tag_user'
  get 'user/:name/:year/:month/:day' => 'users#show_date'
  match 'user/:name' => 'users#update', via: [:put], as: 'update_user'

  match '*a' => 'application#not_found', via: [:get, :post, :put, :delete]
end
