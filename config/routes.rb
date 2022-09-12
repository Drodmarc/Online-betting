Rails.application.routes.draw do
  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    root to: 'home#index'

    namespace :users do
      resource :profile, only: :show
      resource :invite_people, path: 'invite-people', only: :show
      resources :addresses
      resources :lotteries
      resources :offers, path: 'shop', only: :index do
        post :order
      end
      resources :winners, only: [:show, :update]
      resources :shares, only: [:show, :update]
      resources :feedbacks, only: [:show, :index]
      scope  :orders, path: 'orders', as: 'orders' do
        put "cancel/:order_id", to: 'orders#cancel'
      end
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      devise_for :users, controllers: { sessions: 'admin/sessions' }
      root to: 'dashboards#index'

      resources :users, only: :index do
        resources :increases, path: 'orders/increase', only: [:new, :create]
        resources :deducts, path: 'orders/deduct', only: [:new, :create]
        resources :bonuses, path: 'orders/bonus', only: [:new, :create]
      end
      resources :items, path: 'items-list', except: :show do
        put :start, :pause, :end, :cancel
      end
      resources :categories, except: :show
      resources :bets, path: 'bets-list', only: :index do
        put :cancel
      end
      resources :winners, path: 'winners-list', only: :index do
        put :submit, :pay, :ship, :deliver, :publish, :remove_publish
      end
      resources :offers, path: 'offers-list', except: :show
      resources :orders, path: 'orders-list', only: :index do
        put :pay, :cancel
      end
      resources :invites, path: 'invites-list', only: :index
    end
  end
end