# == Route Map (Updated 2014-04-11 19:36)
#
#      Prefix Verb   URI Pattern                 Controller#Action
#       games GET    /games(.:format)            games#index
#             POST   /games(.:format)            games#create
#    new_game GET    /games/new(.:format)        games#new
#   edit_game GET    /games/:id/edit(.:format)   games#edit
#        game GET    /games/:id(.:format)        games#show
#             PATCH  /games/:id(.:format)        games#update
#             PUT    /games/:id(.:format)        games#update
#             DELETE /games/:id(.:format)        games#destroy
#     players GET    /players(.:format)          players#index
#             POST   /players(.:format)          players#create
#  new_player GET    /players/new(.:format)      players#new
# edit_player GET    /players/:id/edit(.:format) players#edit
#      player GET    /players/:id(.:format)      players#show
#             PATCH  /players/:id(.:format)      players#update
#             PUT    /players/:id(.:format)      players#update
#             DELETE /players/:id(.:format)      players#destroy
#        root GET    /                           wellcome#index
#

Bowling::Application.routes.draw do

  resources :games
  resources :players
  root 'wellcome#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
