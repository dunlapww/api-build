class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    merchant = Merchant.find_by_id(params[:merchant_id])
    return nil_merchant if merchant.nil?
    render json: ItemSerializer.new(merchant.items)
  end

  private
  
  def nil_merchant
    render json: ErrorSerializer.new('merchant must exist'), status: :bad_request
  end
end
