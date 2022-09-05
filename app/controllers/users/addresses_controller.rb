class Users::AddressesController < ApplicationController
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
    @addresses = current_user.addresses.includes(:region, :province, :city, :barangay)
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.user = current_user

    if @address.save
      flash[:notice] = "Successfully Created"
      redirect_to users_addresses_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @address.update(address_params)
      flash[:notice] = "Successfully Updated"
      redirect_to users_addresses_path
    else
      render :edit
    end
  end

  def destroy
    if @address.destroy
      flash[:notice] = "Successfully deleted"
      redirect_to users_addresses_path
    end
  end

  private

  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:name, :phone_number, :street_address, :genre, :region_id, :province_id, :city_id, :barangay_id, :remark, :is_default)
  end
end