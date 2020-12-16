class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchants = Merchant.search(merchant_params[:name])
    render json: MerchantSerializer.new(merchants)
  end

  private

  def merchant_params
    params.permit(:name, :created_at, :updated_at)
  end
end