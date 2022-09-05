class Admin::UsersController < AdminController
  def index
    @users = User.where(role: :client)
    if params['email'].present?
      @users = @users.where(email: params['email'])
    end
  end
end