# frozen_string_literal: true

class Api::BenchesController < ApplicationController
  def index
    @benches = bounds ? Api::Bench.in_bounds(bounds) : Api::Bench.all
    # render json: @benches
  end

  def create
    @bench = Api::Bench.new(bench_params)
    if @bench.save

    else
      render json: @bench.errors.full_messages, status: 422
    end
  end

  private

  def bench_params
    params.require(:bench).permit(:description, :lat, :lng)
  end

  def bounds
    params[:bounds]
  end
end
