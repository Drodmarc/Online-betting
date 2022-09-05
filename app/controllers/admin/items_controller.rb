class Admin::ItemsController < AdminController
  before_action :set_item, except: [:index, :new, :create]

  def index
    @items = Item.includes(:category)
    if params['name'].present?
      @items = @items.where(name: params['name'])
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = "Successfully Created"
      redirect_to admin_items_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      flash[:notice] = "Successfully Updated"
      redirect_to admin_items_path
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      flash[:notice] = "Successfully Deleted"
    else
      flash[:alert] = "Can't delete this item!"
    end
    redirect_to admin_items_path
  end

  def start
    if @item.start!
      flash[:notice] = "Started Successfully"
    else
      flash[:alert] = @item.errors.full_messages.join(', ')
    end
    redirect_to admin_items_path
  end

  def pause
    if @item.pause!
      flash[:notice] = "Paused Successfully"
    else
      flash[:alert] = @item.errors.full_messages.join(', ')
    end
    redirect_to admin_items_path
  end

  def end
    if @item.end!
      flash[:notice] = "Ended Successfully"
    else
      flash[:alert] = @item.errors.full_messages.join(', ')
    end
    redirect_to admin_items_path
  end

  def cancel
    if @item.cancel!
      flash[:notice] = "Cancelled Successfully"
    else
      flash[:alert] = @item.errors.full_messages.join(', ')
    end
    redirect_to admin_items_path
  end

  private

  def item_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_bets, :state, :batch_at, :online_at, :offline_at, :start_at, :status, :category_id)
  end

  def set_item
    @item = Item.find(params[:id] || params[:item_id])
  end
end