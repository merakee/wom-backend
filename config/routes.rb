Rails.application.routes.draw do
#devise_for :users
  root 'api/v0/sessions#create'

  # API related routes
  namespace :api, :defaults => {:format => :json} do  # url: domain/api
    namespace :v0 do  # full path version number /api/v0/
    #scope module: :v0, constraints: APIConstraints.new(version: 0, default: true) do # with constraints - no need to specif api/v0/ api/ is enough

    # root ---------------
      root 'sessions#create'

      # DEVISE ---------------
      devise_for :users, skip: :all
      devise_scope :api_v0_user do
      # devise/registrations
      #get 'sign_up' => 'registrations#new', :as => :new_user_registration
        post 'signup' => 'registrations#create', :as => :user_registration
        #get 'accounts/cancel' => 'registrations#cancel', :as => :cancel_user_registration
        #get 'accounts/edit' => 'registrations#edit', :as => :edit_user_registration
        #put 'accouts' => 'registrations#update'
        #delete 'accounts/cancel' => 'registrations#destroy'

        # devise/sessions
        #get 'signin' => 'sessions#new', :as => :new_user_session
        post 'signin' => 'sessions#create', :as => :user_session
        delete 'signout' => 'sessions#destroy', :as => :destroy_user_session
      end

      # RESOURCES ---------------
      #resources :users, only: [:show]
      post 'users/profile' => 'users#profile'
      post 'users/update' => 'users#update'
            
      # contents 
      #resources :contents, only: [:index,:create]
      # use post t get content : added duplicate path for getting content
      post 'contents/create' => 'contents#create'
      post 'contents/getlist' => 'contents#index'
      post 'contents/getcontent' => 'contents#get_content'
      post 'contents/getrecent' => 'contents#get_recent'
      post 'contents/delete' => 'contents#destroy'
      
      # user response 
      #resources :user_responses, only: [:create]
      post 'contents/response' => 'user_responses#create'

      # favorite content  
      #resources :favorite_contents, only: [:create]
      post 'favorite_contents/favorite' => 'favorite_contents#create'
      post 'favorite_contents/unfavorite' => 'favorite_contents#destroy'
      post 'favorite_contents/getlist' => 'favorite_contents#getlist'
                  
      # conent flag       
      post 'contents/flag' => 'content_flag#create'
            
      # comments
      #resources :comments, only: [:create]
      post 'comments/create' => 'comments#create'
      post 'comments/getlist' => 'comments#index'

      # comment response
      #resources :comment_responses, only: [:create]
      post 'comments/response' => 'comment_responses#create'
      
      # history
      post 'history/contents' => 'history#contents'
      post 'history/comments' => 'history#comments'
      
      # notifications
      post 'notifications/getlist' => 'notifications#index'
      post 'notifications/count' => 'notifications#count'
      post 'notifications/reset/content' => 'notifications#content_reset'
      post 'notifications/reset/comment' => 'notifications#comment_reset'
      
    end
  end

  # for sidekiq monitoring
  # require 'sidekiq/web'
  # map '/sidekiq' do
  # use Rack::Auth::Basic, "Protected Area" do |username, password|
  # username == 'wom-admin' && password == 'freelogue2014'
  # end

  # catch all routes
  match "*all" , :to => 'application#routing_error', :via => :all, :defaults => {:format => :json}
end

=begin
# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".

# You can have the root of your site routed with "root"
# root 'welcome#index'

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
=end

