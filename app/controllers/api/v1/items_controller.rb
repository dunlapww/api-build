class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    item = Item.create(item_params)
    render json: ItemSerializer.new(item)
  end

  def destroy
    Item.find(params[:id]).delete
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
