class Api::V1::RevenueController < ApplicationController
  def revenue
    revenue = Invoice.revenue(revenue_params)
    render json: RevenueSerializer.new(revenue, revenue_params)
  end

  private

  def revenue_params
    params.permit(:start, :end)
  end
end