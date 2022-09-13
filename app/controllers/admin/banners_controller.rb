class Admin::BannersController < AdminController
  before_action :set_banner, only: [:edit, :update, :destroy]
  def index
    @banners = Banner.all
    @banners = @banners.where(status: params[:status]) if params[:status].present?
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(banners_params)
    if @banner.save
      flash[:notice] = "Successfully Created"
      redirect_to admin_banners_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @banner.update(banners_params)
      flash[:notice] = "Successfully Updated"
      redirect_to admin_banners_path
    else
      render :edit
    end
  end

  def destroy
    if @banner.destroy
      flash[:notice] = "Successfully deleted"
    else
      flash[:alert] = @banner.errors.full_messages.join(', ')
    end
    redirect_to admin_banners_path
  end

  private

  def banners_params
    params.require(:banner).permit(:preview, :status, :online_at, :offline_at)
  end

  def set_banner
    @banner = Banner.find(params[:id])
  end
end
