# frozen_string_literal: true

require 'trout/map/builder'
require 'trout/map/search'

# Answers logical questions about subway routes
module Trout
  class Map
    def initialize(routes, stops)
      @routes = routes
      @stops  = stops
    end

    def routes
      @routes.values
    end

    def stops
      @stops.values
    end

    def route_with_most_stops
      @routes.each_value.max_by { |r| r.stops.size }
    end

    def route_with_fewest_stops
      @routes.each_value.min_by { |r| r.stops.size }
    end

    def transfer_stops
      @stops.each_value.select { |stop| stop.routes.size > 1 }
    end

    def routes_traveled(origin_name, destination_name)
      origin = find_stop(origin_name)
      destination = find_stop(destination_name)

      search = Search.new(transfer_stops)

      paths = []
      origin.routes.each do |route1|
        destination.routes.each do |route2|
          paths << search.find_path(route1, route2)
        end
      end

      return paths.compact.min_by(&:size)
    end

    private

    # Find stop by name. Limited fuzzy match
    # eg. 'hynes' -> "Hynes"
    #     'park' -> "Park Street"
    def find_stop(name)
      stop = stops.find { |s| s.name == name }

      if stop.nil? # No exact match found, try fuzzier match.
        stop = stops.find { |s| s.name.downcase.start_with?(name.downcase) }
        raise ArgumentError, "Unknown stop: #{name}" if stop.nil?
        warn "Expanded #{name.inspect} to #{stop.name.inspect}"
      end

      stop
    end
  end
end
