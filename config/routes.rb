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
      resources :items, path: 'item-list', except: :show do
        put :start, :pause, :end, :cancel
      end
      resources :categories, path: 'category', except: :show
      resources :bets, path: 'bet-list', only: :index do
        put :cancel
      end
      resources :winners, path: 'winner-list', only: :index do
        put :submit, :pay, :ship, :deliver, :publish, :remove_publish
      end
      resources :offers, except: :show
    end
  end
end
