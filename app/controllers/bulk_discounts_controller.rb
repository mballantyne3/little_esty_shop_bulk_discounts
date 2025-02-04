class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @merchant.bulk_discounts.create!(percent_discount: params[:percent_discount], qty_threshold: params[:qty_threshold])

    redirect_to "/merchant/#{@merchant.id}/bulk_discounts"
  end

  def destroy
    bd = BulkDiscount.find_by!(id: params[:id], merchant_id: params[:merchant_id])
    bd.destroy!
    redirect_to "/merchant/#{params[:merchant_id]}/bulk_discounts"
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
    @bulk_discount.update(bd_params)
    @bulk_discount.save
    redirect_to "/merchant/#{params[:merchant_id]}/bulk_discounts/#{@bulk_discount.id}"
  end

  private

  def bd_params
    params.permit(:percent_discount, :qty_threshold)
  end
end
