require "bundler/gem_tasks"
require "rspec/core/rake_task"

require_relative 'lib/trout/version'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Build docker image'
task :docker do
  cmd = %W(
    docker build -t trout -t trout:#{Trout::VERSION} --build-arg VERSION=#{Trout::VERSION} .
  )
  sh *cmd
end
