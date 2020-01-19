# frozen_string_literal: true

require 'shellwords'
require 'stringio'

require 'trout'

# Test helper class. This "runs" a trout command in the same process
# as the tests, capturing exit status, stdout and stderr and returning
# them in a Result object
module Trout
  module Runner
    Result = Struct.new(:args, :stdout, :stderr, :status, keyword_init: true) do
      def output
        Parser.new(stdout)
      end

      private

      class Parser
        def initialize(output)
          @output = output
        end

        def from_yaml
          YAML.safe_load(@output)
        end

        def from_json
          JSON.parse(@output)
        end
      end
    end

    # Run trout with given arguments, capturing stderr, stdout, and exit status
    def self.run(args)
      args    = Shellwords.split(args) if args.is_a?(String)
      result  = Result.new(args: args, status: 0)
      fakeout = StringIO.new
      fakeerr = StringIO.new

      begin
        realout = $stdout
        $stdout = fakeout
        realerr = $stderr
        $stderr = fakeerr
        Trout::CLI.run('trout', args)
      rescue SystemExit => e
        result.status = e.status
      ensure
        $stdout = realout
        $stderr = realerr
      end

      result.stdout = fakeout.string
      result.stderr = fakeerr.string

      result
    end
  end
end
