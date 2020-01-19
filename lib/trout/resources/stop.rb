# frozen_string_literal: true

module Trout
  class Stop < Resource
    attr_reader :id, :name
    attr_accessor :routes

    def initialize(data)
      @id   = data['id'].to_sym
      @name = data['attributes']['name']

      # Populated manually
      @routes = []
    end
  end
end
