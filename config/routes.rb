Rails.application.routes.draw do
  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    root to: 'home#index'

    namespace :users do
      resource :profile, only: :show
      resources :addresses
      get '/invite-people/', to: 'invite_people#show'
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      devise_for :users, controllers: { sessions: 'admin/sessions' }
      root to: 'dashboard#index'
    end
  end
end
