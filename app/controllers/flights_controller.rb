class FlightsController < ApplicationController
  before_action :set_flight, only: [:show, :update, :destroy]
  before_action :validate_search_params, only: [:get_filtered_flights]


  @@page_size = 5
  # GET /flights
  def index
    @flights = Flight.all

    render json: @flights
  end

  # GET /flights/1
  def show
    render json: @flight
  end

  def get_all_flights
    flights = Flight.all.order(:cost)
    return render json: {"flights": flights.limit(@@page_size).offset((params[:page].to_i-1)* @@page_size ), "count": flights.length}, status: 200
  end

  #POST /get_filtered_flights
  def get_filtered_flights
    journey_data = {}
    if(params[:type] == 0)
      journey_data = Flight.find_flights_with_params(params)
    else
      journey_data = Flight.find_two_way_flights_with_params(params)
    end
    return render json: journey_data, status: 200
  end

  # POST /flights
  def create
    @flight = Flight.new(flight_params)

    if @flight.save
      render json: @flight, status: :created, location: @flight
    else
      render json: @flight.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /flights/1
  def update
    if @flight.update(flight_params)
      render json: @flight
    else
      render json: @flight.errors, status: :unprocessable_entity
    end
  end

  # DELETE /flights/1
  def destroy
    @flight.destroy
  end

  private
    def validate_search_params
      if(!params.has_key?(:source) || !params.has_key?(:destination))
        return render json:{"error": "Bad Request => source or destination is missing"}, status: 400
      end
      return render json:{"error": "Bad Request => journey 'type'/'passenger_count'/'page' missing "}, status: 400 if(!params.has_key?(:type) || !params.has_key?(:passenger_count) || !params.has_key?(:page))
      return render json:{"error": "Bad Request => return datetime is needed for round trip"}, status: 400 if(params[:type] == 1 && !params.has_key?(:return))
      return render json:{"error": "Bad Request => return is less than departure"}, status: 400 if(params[:type] == 1 && DateTime.parse(params[:return]) < DateTime.parse(params[:departure]))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_flight
      @flight = Flight.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def flight_params
      params.require(:flight).permit(:flight_no, :arrival, :departure, :source, :destination, :seats, :passenger_count, :price_low, :price_high, :type, :return, :page)
    end
end
