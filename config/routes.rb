Rails.application.routes.draw do
  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    root to: 'home#index'

    namespace :users do
      resource :profile, only: :show
      resource :invite_people, path: 'invite-people', only: :show
      resources :addresses
      resources :lotteries
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      devise_for :users, controllers: { sessions: 'admin/sessions' }
      root to: 'dashboards#home'

      resources :dashboards, path: 'user-list', only: :index
      resources :items, path: 'item-list', except: :show
      resources :categories, path: 'category', except: :show
      resources :bets, path: 'bet-list', only: :index
    end
  end
end
