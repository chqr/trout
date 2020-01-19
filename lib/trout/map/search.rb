#
# Identifies which routes must be traveled to get from one
# stop to another.
#
# Uses a simple breadth-first search, treating routes as
# nodes in a graph and transfer stops as edges between them.
#
module Trout
  class Map
    class Search
      ROOT = :__ROOT__

      attr_reader :graph

      def initialize(transfer_stops)
        @graph = {}
        transfer_stops.each do |stop|
          stop.routes.each do |route|
            @graph[route] ||= Set.new
            stop.routes.each do |adj|
              @graph[route] << adj
            end
          end
        end
      end

      # BFS from one route to another.
      def find_path(root, target)
        parents = {}
        queue = []

        parents[root] = ROOT
        queue.push(root)
        until queue.empty?
          node = queue.shift
          return build_path(parents, node) if node == target

          @graph[node].each do |adj|
            next if parents[adj] # already visited
            parents[adj] = node
            queue.push(adj)
          end
        end

        nil # No path found
      end

      private

      def build_path(parents, node, path = {})
        path[node] = true
        parent = parents[node]
        return path.keys.reverse if parent == ROOT
        raise Error, 'Broken path' if parent.nil?
        raise Error, 'Infinite loop?' if path[parent]
        build_path(parents, parent, path)
      end
    end
  end
end
