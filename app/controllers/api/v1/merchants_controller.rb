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
      reasons = merchant.errors.full_messages.to_sentence
      error = Error.new(reasons)
      render json: ErrorSerializer.new(error)
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

  private

  def merchant_params
    params.permit(:name)
  end
end
