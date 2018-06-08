Rails.application.routes.draw do
  resources :bills do
    member do
      get :invoice
      post :rollback
    end
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'emails/index' => 'emails#index'
  post 'emails/sendemail' => 'emails#sendemail'

  resources :venta, :users
  resources :user_sessions, only: [:new, :create, :destroy]


  resources :clientes do
    get :autocompletar, on: :collection
  end

  resources :historials do
    member do
      get :retirar_contacto
      get :retirar_flotante
    end
  end

  resources :attachments, only: [:update, :destroy, :edit]

  get 'private/:path', to: 'files#download',
                         constraints: { path: /.+/ }

  root to: 'clientes#index'
end
