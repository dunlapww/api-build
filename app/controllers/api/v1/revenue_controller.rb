class Api::V1::RevenueController < ApplicationController
  def revenue
    start_date = revenue_params[:start]
    end_date = revenue_params[:end]
    render json: RevenueSerializer.new(Invoice.revenue(start_date,end_date), start_date, end_date)
  end

  private

  def revenue_params
    params.permit(:start, :end)
  end
end