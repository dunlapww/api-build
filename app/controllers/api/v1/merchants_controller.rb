class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    merchant = Merchant.find_by_id(params[:id])
    return nil_merchant if merchant.nil?
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
    merchant = Merchant.find_by_id(params[:id])
    return nil_merchant if merchant.nil?
    merchant.delete
  end

  def update
    merchant = Merchant.find_by_id(params[:id])
    return nil_merchant if merchant.nil?

    if merchant.update(merchant_params)
      render json: MerchantSerializer.new(merchant)
    else
      error_messages = merchant.errors.full_messages.to_sentence
      render json: ErrorSerializer.new(error_messages), status: :bad_request
    end
  end

  def revenue
    merchant = Merchant.find_by_id(query_params[:merchant_id])
    return nil_merchant if merchant.nil?
    render json: RevenueSerializer.new(merchant.revenue, query_params)
  end

  private

  def merchant_params
    params.permit(:name)
  end

  def query_params
    params.permit(:merchant_id)
  end

  def nil_merchant
    render json: ErrorSerializer.new('merchant must exist'), status: :bad_request
  end
end
