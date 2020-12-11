class Api::V1::ItemsController < ApplicationController
  def index
    #render json: ItemSerializer.new(Item.all).serializable_hash
    render json: ItemSerializer.new(Item.all).serialized_json
  end
end