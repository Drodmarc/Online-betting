Rails.application.routes.draw do

  root to: 'home#index'
  constraints(ClientDomainConstraint.new) do
  end

  constraints(AdminDomainConstraint.new) do
  end
end
