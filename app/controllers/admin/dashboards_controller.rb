class Admin::DashboardsController < AdminController

  def index
    @users = User.where(role: :client)
    unless params['search'].blank?
      @users = @users.where(email: params['search'])
    else

    end
  end
end