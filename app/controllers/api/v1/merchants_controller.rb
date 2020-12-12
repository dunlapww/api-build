class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all).serialized_json
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id])).serialized_json
  end

  def create
    merchant = Merchant.new(merchant_params)
    if merchant.save
      render json: MerchantSerializer.new(Merchant.last).serialized_json 
    else
      reasons = merchant.errors.full_messages.to_sentence
      error = Error.new(reasons)
      render json: ErrorSerializer.new(error) 
    end
     
  end

  private
  def merchant_params
    params.require(:merchant).permit(:name, :created_at, :updated_at)
  end
end
