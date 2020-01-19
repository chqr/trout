# frozen_string_literal: true

module Trout
  class Route < Resource
    attr_reader :id, :name
    attr_accessor :stops

    def initialize(data)
      @id   = data['id'].to_sym
      @name = data['attributes']['long_name']

      # Populated manually
      @stops = []
    end
  end
end
