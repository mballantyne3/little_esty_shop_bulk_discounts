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
    merchant = Merchant.find(params[:merchant_id])
    bd = BulkDiscount.find(params[:id])
    bd.destroy
    redirect_to "/merchant/#{merchant.id}/bulk_discounts"
  end
end
