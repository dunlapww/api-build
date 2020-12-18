class Api::V1::Items::MerchantsController < ApplicationController
  def index
    item = Item.find(params[:item_id])
    return nil_item if item.nil?
    render json: MerchantSerializer.new(item.merchant)
  end

  private

  def nil_item
    render json: ErrorSerializer.new('item must exist'), status: :bad_request
  end
end
