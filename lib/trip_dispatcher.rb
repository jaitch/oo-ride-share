require 'csv'
require 'time'

require_relative 'passenger'
require_relative 'trip'
require_relative 'driver'

module RideShare
  class TripDispatcher
    attr_reader :passengers, :trips, :drivers

    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      connect_trips
    end

    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id)
      Driver.validate_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
      #{trips.count} trips, \
      #{drivers.count} drivers, \
      #{passengers.count} passengers>"
    end

    private

    def connect_trips
      @trips.each do |trip|
        passenger = find_passenger(trip.passenger_id)
        driver = find_driver(trip.driver_id)
        trip.connect_passenger(passenger)
        trip.connect_driver(driver)
      end
      return trips
    end
    # def request_trip(passenger_id)
    #   available_drivers = @drivers.select(|driver| driver.status == :AVAILABLE)
    #   id = @trips.length + 1

    #   passenger = find_passenger(passenger_id)
    #   chosen_driver_id = available_drivers[0].id
    #   chosen_driver = find_driver(chosen_driver_id)
    #   trip = Trip.new(id, chosen_driver_id, passenger, passenger_id, Time.now, nil, nil, nil, chosen_driver)



    # end
  end
end
