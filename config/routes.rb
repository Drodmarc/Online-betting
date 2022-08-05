Rails.application.routes.draw do
  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    root to: 'home#index'

    namespace :users do
      resource :profile
    end
  end

  constraints(AdminDomainConstraint.new) do
  end
end
