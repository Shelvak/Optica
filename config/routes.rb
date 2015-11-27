Optica::Application.routes.draw do
  match 'emails/index' => 'emails#index', :via => 'get'
  match 'emails/sendemail' => 'emails#sendemail', :via => 'post'

  resources :recetes, :venta,:users
  resources :user_sessions, :only => [:new, :create, :destroy]


  resources :clientes do
    get :autocompletar, on: :collection
  end

  resources :historials do
    get :retirar_contacto, on: :member
    get :retirar_flotante, on: :member
  end

  root :to => 'clientes#index'
end
