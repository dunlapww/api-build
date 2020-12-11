class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all).serialized_json
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id])).serialized_json
  end
end
