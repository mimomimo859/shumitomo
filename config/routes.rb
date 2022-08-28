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

  scope module: :public do
   resources :posts
   resources :posts do
    resource :likes, only: [:create, :destroy]
    resource :comments, only: [:create, :destroy]
   end
   get 'end_user/profile' => 'end_users#profile', as: 'profile'
   get 'end_user/unsubscribe' => 'end_users#unsubscribe', as: 'unsubscribe'
   patch 'end_user/withdraw' => 'end_users#withdraw', as: 'withdraw'
   resources :end_users, only: [:update, :create, :edit, :show]
   root to: "homes#top"
   get 'homes/about' => 'homes#about', as: 'about'
  end

  namespace :admin do
   resources :end_users, only: [:index, :show, :edit, :update]
   resources :comments, only: [:destroy]
   get 'homes/top' => "homes#top", as: 'top'
  end


end
