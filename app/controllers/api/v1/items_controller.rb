class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def item_merchant
    merchant = Item.find(params[:item_id]).merchant
    render json: MerchantSerializer.new(merchant)
  end
end
