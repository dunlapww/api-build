class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def create
    merchant = Merchant.new(merchant_params)
    if merchant.save
      render json: MerchantSerializer.new(merchant)
    else
      error_messages = merchant.errors.full_messages.to_sentence
      render json: ErrorSerializer.new(error_messages), status: :bad_request
    end
  end

  def destroy
    merchant = Merchant.find(params[:id])
    merchant.delete
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update(merchant_params)
    render json: MerchantSerializer.new(merchant)
  end

  def revenue
    revenue = Merchant.revenue(revenue_params[:merchant_id])
    render json: RevenueSerializer.new(revenue, revenue_params)
  end

  private

  def merchant_params
    params.permit(:name)
  end

  def revenue_params
    params.permit(:merchant_id)
  end

end
