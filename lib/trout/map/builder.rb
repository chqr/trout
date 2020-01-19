# frozen_string_literal: true

#
# Pulls data from MBTA's API and massages it into a convenient form for the
# map class.
#
module Trout
  class Map
    class Builder
      # Subway transport types
      SUBWAY_TYPES = [0, 1].freeze

      # Build and return a new Map
      def build
        routes = get_routes

        # Fetch stops, populating relationships between routes/stops
        stops = {}
        routes.each do |route|
          get_stops(route).each do |stop|
            stops[stop.id] ||= stop
            stops[stop.id].routes << route
            route.stops << stop
          end
        end

        routes = array_to_h(routes)

        Map.new(routes, stops)
      end

      private

      # Fetch all subway routes
      def get_routes
        Route.fetch(filter: { type: SUBWAY_TYPES })
      end

      # Fetch stops for the given route
      def get_stops(route)
        Stop.fetch(filter: { route: route.id },
                   fields: ['name'])
      end

      # Convert array of objects to hash keyed by id
      def array_to_h(array)
        array.map { |obj| [obj.id, obj] }.to_h
      end
    end
  end
end
