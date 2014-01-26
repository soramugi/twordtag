Twordtag::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with 'rake routes'.
  root to: 'tops#index'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signout' => 'sessions#destroy'

  match '/analysis' => 'tops#analysis', via: [:get, :post]

  get '/tags' => 'tags#index'
  get '/tags/:word' => 'tags#show', as: 'tag'
end
