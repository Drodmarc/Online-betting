class Admin::DashboardsController < AdminController

  def index
    @users = User.where(role: :client)
    if params['user'].present?
      @users = @users.where(email: params['user'])
    end
  end
end