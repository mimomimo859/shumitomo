Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # 顧客用
  # URL /end_user/sign_in ...
  devise_for :end_users, controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
  }

  devise_scope :end_user do
    post 'end_users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  get "search" => "searches#search", as: 'search'
  get "search_confirm" => "searches#search_confirm", as: 'search_confirm'



  scope module: :public do
   root to: "homes#top"
   get 'homes/about' => 'homes#about', as: 'about'
   get 'end_user/my_profile' => 'end_users#my_profile', as: 'my_profile'
   get 'end_user/unsubscribe' => 'end_users#unsubscribe', as: 'unsubscribe'
   patch 'end_user/withdraw' => 'end_users#withdraw', as: 'withdraw'

   resources :posts do
    resource :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
    collection do
     get 'confirm'
    end
   end

   resources :rooms, only: [:create, :show]
   resources :chats, only: [:create]

   resources :end_users, only: [:update, :create, :edit, :show] do
    member do
     get :follows, :followers
    end
    resources :relationships, only: [:create, :destroy, :index]
    member do
     get :likes
    end
   end

  end

  namespace :admin do
   resources :posts, only: [:show]
   resources :end_users, only: [:index, :show, :edit, :update]
   resources :comments, only: [:destroy]
   get "search" => "searches#search", as: 'search'
   get 'homes/top' => "homes#top", as: 'top'
  end

end
