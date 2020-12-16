class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchants = Merchant.find_all(merchant_params)
    render json: MerchantSerializer.new(merchants)
  end

  private

  def merchant_params
    params.permit(:name, :created_at, :updated_at)
  end
end