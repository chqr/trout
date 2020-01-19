# frozen_string_literal: true

require 'trout/resource/connection'

#
# Base class for all objects fetched from the MBTA API
#
module Trout
  class Resource
    class << self
      # Reader/writer for the Faraday connection object, which is shared
      # by all Model subclasses
      def connection
        if @@connection.nil?
          raise ArgumentError, 'You must provide a Faraday connection with '\
                               'connection= or call configure first!'
        end
        @@connection
      end

      def configure(**options)
        @@connection = Connection.build(**options)
      end

      def connection=(conn)
        @@connection = conn
      end

      # Lowercase name of this object type
      # Eg. 'Route' -> 'route'
      def type_name
        @type_name ||= name.split('::').last.downcase.to_s
      end

      # Request path for this endpoint
      # Eg. 'Route' -> /routes
      def path
        "/#{type_name}s" # TODO - use pluralize from active-support
      end

      # Fetch multiple objects from the MBTA API with a GET request.
      #
      # Eg.
      #
      #   GET /stops?filter[route]=Red&fields[stop]=name
      #   GET /routes?filter[type]=0,1&include=line
      #   GET /lines?filter[id]=line-Red,line-Green
      #
      def fetch(filter: {}, fields: [], include: [])
        params = {}

        unless fields.empty?
          params["fields[#{type_name}]"] = fields * ','
        end

        filter.each_pair do |attr, value|
          value = value * ',' if value.kind_of?(Array)
          params["filter[#{attr}]"] = value.to_s
        end

        unless include.empty?
          params['include'] = include * ','
        end

        response = connection.get(path, params)
        response.body['data'].map do |data|
          new(data)
        end
      end
    end

    # Two objects are equal if they have the same id
    def ==(other)
      other.class == self.class && other.id == self.id
    end

    # Make sure we can use these objects as hash keys
    alias_method :eql?, :==

    def hash
      [self.class, self.id].hash
    end
  end
end
