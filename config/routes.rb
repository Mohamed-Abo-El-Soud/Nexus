Rails.application.routes.draw do

  resources :messages, only: [:create]
  
  get 'messages/inbox'

  get 'messages/sent'

  get 'messages/spam'

  get 'messages/trash'
  
  get 'password_resets/new'

  get 'password_resets/edit'

  # get 'accounts/new'

  # get 'accounts/search'

  # get 'accounts/inbox'

  # get 'accounts/sent'

  # get 'accounts/spam'

  # get 'accounts/trash'

  get '/about' => 'static_pages#about'

  get '/contact' => 'static_pages#contact'

  get '/help' => 'static_pages#help'

  root "static_pages#home"
  
  # get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  
  resources :accounts
  
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
#                   Prefix Verb   URI Pattern                             Controller#Action
#     password_resets_new GET    /password_resets/new(.:format)          password_resets#new
#   password_resets_edit GET    /password_resets/edit(.:format)         password_resets#edit
#                   about GET    /about(.:format)                        static_pages#about
#                 contact GET    /contact(.:format)                      static_pages#contact
#                   help GET    /help(.:format)                         static_pages#help
#                   root GET    /                                       static_pages#home
#                   login POST   /login(.:format)                        sessions#create
#                 logout DELETE /logout(.:format)                       sessions#destroy
#               accounts GET    /accounts(.:format)                     accounts#index
#                         POST   /accounts(.:format)                     accounts#create
#             new_account GET    /accounts/new(.:format)                 accounts#new
#           edit_account GET    /accounts/:id/edit(.:format)            accounts#edit
#                 account GET    /accounts/:id(.:format)                 accounts#show
#                         PATCH  /accounts/:id(.:format)                 accounts#update
#                         PUT    /accounts/:id(.:format)                 accounts#update
#                         DELETE /accounts/:id(.:format)                 accounts#destroy
# edit_account_activation GET    /account_activations/:id/edit(.:format) account_activations#edit
#         password_resets POST   /password_resets(.:format)              password_resets#create
#     new_password_reset GET    /password_resets/new(.:format)          password_resets#new
#     edit_password_reset GET    /password_resets/:id/edit(.:format)     password_resets#edit
#         password_reset PATCH  /password_resets/:id(.:format)          password_resets#update
#                         PUT    /password_resets/:id(.:format)          password_resets#update

end
