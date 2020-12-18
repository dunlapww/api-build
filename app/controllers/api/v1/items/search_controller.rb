class Api::V1::Items::SearchController < ApplicationController
  def find_all
    items = Item.find_all(item_params)
    render json: ItemSerializer.new(items)
  end

  def find_first
    item = Item.find_all(item_params).first
    render json: ItemSerializer.new(item)
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id, :created_at, :updated_at, :quantity)
  end
end
