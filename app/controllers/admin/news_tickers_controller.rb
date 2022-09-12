class Admin::NewsTickersController < AdminController
  before_action :set_news_ticker, only: [:edit, :update, :destroy]

  def index
    @news_tickers = NewsTicker.all
    @news_tickers = @news_tickers.where(content: params[:content]) if params[:content].present?
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(news_tickers_params)
    @news_ticker.admin = current_admin_user
    if @news_ticker.save
      flash[:notice] = "Successfully Created"
      redirect_to admin_news_tickers_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @news_ticker.update(news_tickers_params)
      flash[:notice] = "Successfully Updated"
      redirect_to admin_news_tickers_path
    else
      render :edit
    end
  end

  def destroy
    if @news_ticker.destroy
      flash[:notice] = "Successfully deleted"
    else
      flash[:alert] = @news_ticker.errors.full_messages.join(', ')
    end
    redirect_to admin_news_tickers_path
  end

  private

  def news_tickers_params
    params.require(:news_ticker).permit(:content, :status)
  end

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end
end