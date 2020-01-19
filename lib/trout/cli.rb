# frozen_string_literal: true
#
# Specifies command-line interface, using the Clamp library
#
module Trout
  class CLI < Clamp::Command

    # Global options
    option '--debug', :flag, 'Enable debug logging'

    option '--format', 'FORMAT',
           'Output format: "json", "yaml"',
           default: :yaml do |arg|
             raise ArgumentError unless %w( json yaml ).include?(arg)
             arg.to_sym
           end

    option '--api-key', 'KEY',
           'MBTA api key',
           environment_variable: 'MBTA_API_KEY'

    attr_reader :map

    # Main method for this CLI program
    def execute
      setup
      begin
        data = main
      rescue ArgumentError => e
        $stderr.puts e.message
        exit 1
      end
      puts format_data(data)
    end

    # Initialize logger, api client, etc. based on supplied CLI options.
    def setup
      logger = debug? ? Logger.new($stderr) : nil
      Resource.configure(api_key: api_key, logger: logger)

      @map = Map::Builder.new.build
    end

    # Format data based on supplied CLI options
    def format_data(data)
      case format
      when :json
        JSON.pretty_generate(data)
      else # default to YAML
        data.to_yaml.sub(/\A\-\-\-\n/, '')
      end
    end

    # Subcommands should override this method, returning
    # simple JSON-style output to be presented to user
    def main
    end

    subcommand 'list', 'List all subway routes' do
      def main
        map.routes.collect(&:name)
      end
    end

    subcommand 'most-stops', 'Show route with the most stops' do
      def main
        route = map.route_with_most_stops
        { route.name => route.stops.size }
      end
    end

    subcommand 'fewest-stops', 'Show route with the fewest stops' do
      def main
        route = map.route_with_fewest_stops
        { route.name => route.stops.size }
      end
    end

    subcommand 'transfer-stops', 'List all stops that connect multiple routes' do
      def main
        stops = map.transfer_stops
        stops.collect do |stop, routes|
          [stop.name, stop.routes.collect(&:name)]
        end.to_h
      end
    end

    subcommand 'routes-traveled', 'List routes in a path from one stop to another' do
      parameter 'FROM', 'Starting stop',    attribute_name: :origin_stop
      parameter 'TO',   'Destination stop', attribute_name: :destination_stop

      def main
        map.routes_traveled(origin_stop, destination_stop).collect(&:name)
      end
    end
  end
end
