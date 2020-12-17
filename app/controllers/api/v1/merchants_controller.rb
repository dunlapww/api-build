class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
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
    #should I render something here to let them know they succesfully deleted a record? 
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update(merchant_params)
    render json: MerchantSerializer.new(merchant)
  end

  def revenue
    merchant = Merchant.find(query_params[:merchant_id])
    render json: RevenueSerializer.new(merchant.revenue, query_params)
  end

  private

  def merchant_params
    params.permit(:name)
  end

  def query_params
    params.permit(:merchant_id)
  end
end
