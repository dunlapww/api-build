class Api::V1::RevenueController < ApplicationController
  def revenue
    revenue = Invoice.revenue(query_params)
    render json: RevenueSerializer.new(revenue, query_params)
  end

  private

  def query_params
    params.permit(:start, :end)
  end
end
