class Api::V1::RevenueController < ApplicationController
  def total_revenue
    if invalid_params?
      return render json: ErrorSerializer.new('invalid date'), status: :bad_request
    else
      revenue = Invoice.revenue(query_params)
      render json: RevenueSerializer.new(revenue, query_params)
    end
  end

  private

  def query_params
    params.permit(:start, :end)
  end

  def invalid_params?
    invalid_params = false
    query_params.each do |param, value|
      begin
        value.to_date
      rescue ArgumentError
        invalid_params = true
      end
    end
    invalid_params
  end
end
