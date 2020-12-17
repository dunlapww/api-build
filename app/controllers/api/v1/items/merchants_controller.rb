class Api::V1::Items::MerchantsController < ApplicationController
  def index
    merchant = Item.find(params[:item_id]).merchant
    render json: MerchantSerializer.new(merchant)
  end
end