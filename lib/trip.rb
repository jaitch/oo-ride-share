require 'csv'
require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver, :driver_id

    def initialize(id:, driver_id: nil,
      passenger: nil, passenger_id: nil,
      start_time:, end_time:, cost: nil, rating:, driver: nil)
      super(id)

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id

      elsif passenger_id
        @passenger_id = passenger_id

      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end

      @start_time = start_time
      @end_time = end_time
      @cost = cost
      @rating = rating
      @driver = driver
      @driver_id = driver_id

      raise ArgumentError.new("End time must be after start time") if end_time != nil && start_time > end_time

      raise ArgumentError.new("Invalid rating #{@rating}") if @rating != nil && (@rating > 5 || @rating < 1)
    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def connect_passenger(passenger)
      @passenger = passenger
      passenger.add_trip(self)
    end

    def connect_driver(driver)
      @driver = driver
      driver.add_trip(self)
    end

    def calculate_duration_seconds
      if end_time == nil
        return 0
      end
      return end_time - start_time
    end

    private

    def self.from_csv(record)
      return self.new(
        id: record[:id],
        driver_id: record[:driver_id],
        driver: record[:driver],
        passenger_id: record[:passenger_id],
        start_time: Time.parse(record[:start_time]),
        end_time: Time.parse(record[:end_time]),
        cost: record[:cost],
        rating: record[:rating]
      )
    end
  end
end
