class Api::V1::Merchants::SearchController < ApplicationController
  def find_all
    merchants = Merchant.find_all(merchant_params)
    render json: MerchantSerializer.new(merchants)
  end
  
  def find_first
    merchant = Merchant.find_all(merchant_params).first
    render json: MerchantSerializer.new(merchant)
  end

  def most_revenue
    merchants = Merchant.most_revenue(merchant_params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end

  def most_items
    merchants = Merchant.most_items(merchant_params[:quantity])
    render json: MerchantSerializer.new(merchants)
  end

  private

  def merchant_params
    params.permit(:name, :created_at, :updated_at, :quantity)
  end
end
