# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  concern :show_paginatable do
    get '(page/:page)', action: :show, on: :collection, as: ''
  end

  get 'home/index'

  resources :gend_images, concerns: :paginatable

  resources :gend_image_pages, only: :show

  resources :pending_gend_images, only: :show

  resources :gend_thumbs, only: :show

  resource :session, only: [:create, :destroy, :new]

  resources :src_images, concerns: :paginatable

  resources :pending_src_images, only: :show

  resources :src_sets, except: :new, concerns: :paginatable

  resources :src_thumbs, only: :show

  resources :users, only: [:create, :new]

  resource :my, only: :show, controller: :my, concerns: :show_paginatable

  resources :terms, only: :index

  resource :search,
           only: :show,
           controller: :search,
           concerns: :show_paginatable

  resources :stats, only: :create

  resources :errors, only: :index

  resource :api_token, only: :create

  resource :dashboard, only: :show, controller: :dashboard

  resources :gend_image_scripts, only: :show

  namespace :api do
    namespace :v3 do
      resources :pending_gend_images, only: :show
      resources :pending_src_images, only: :show
      resources :src_images, concerns: :paginatable, only: [:create, :index]
      resources :gend_images, concerns: :paginatable, only: [:create, :index]
    end
  end

  root 'home#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions
  # automatically):
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
# rubocop:enable Metrics/BlockLength
