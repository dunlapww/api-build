class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    item = Item.find_by(id: params[:id])
    return nil_item if item.nil?

    render json: ItemSerializer.new(item)
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item)
    else
      error_messages = item.errors.full_messages.to_sentence
      render json: ErrorSerializer.new(error_messages), status: :bad_request
    end
  end

  def destroy
    item = Item.find_by(id: params[:id])
    return nil_item if item.nil?

    item.delete
  end

  def update
    item = Item.find_by(id: params[:id])
    return nil_item if item.nil?

    if item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      error_messages = item.errors.full_messages.to_sentence
      render json: ErrorSerializer.new(error_messages), status: :bad_request
    end
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end

  def nil_item
    render json: ErrorSerializer.new('item must exist'), status: :bad_request
  end
end
