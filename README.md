# Trout

Trout (short for "T Routes") is a simple tool for retrieving information about MBTA subway routes.

## Installation

### Ruby

Build the gem (see (Developer Setup)[#developer-setup]) and then

    gem install pkg/trout-0.0.1.gem

### Docker

Build the Docker image (see (Developer Setup)[#developer-setup]) and then

     docker run --rm -it trout --help

## Usage

    $ trout --help
    Usage:
        trout [OPTIONS] SUBCOMMAND [ARG] ...

    Parameters:
        SUBCOMMAND         subcommand
        [ARG] ...          subcommand arguments

    Subcommands:
        list               List all subway routes
        most-stops         Show route with the most stops
        fewest-stops       Show route with the fewest stops
        transfer-stops     List all stops that connect multiple routes
        routes-traveled    Routes that must be taken from one stop to another

    Options:
        --debug            Enable debug logging
        --format FORMAT    Output format: "json", "yaml" (default: :yaml)
        --api-key KEY      MBTA api key (default: $MBTA_API_KEY)
        -h, --help         print help

## Developer Setup

In the project directory:

    rvm use 2.7.0       # See RVM docs for instructions for installing RVM
    gem install bundler # Only needed on a fresh install

    bundle install      # Install dependencies
    rspec               # Run tests
    rake build          # Build gem
    rake docker         # Build Docker image

The tests will generate a SimpleCov report in the project's root directory.
