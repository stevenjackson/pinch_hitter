# Pinch Hitter [![Build Status](https://travis-ci.org/stevenjackson/pinch_hitter.svg?branch=master)](https://travis-ci.org/stevenjackson/pinch_hitter)

Simple replay mock for web service testing


## Installation

Add this line to your application's Gemfile:

    gem 'pinch_hitter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pinch_hitter

## Purpose

Simulate those pesky external web services for testing and gain control over the data that's returned.  Pinch Hitter can stand in for one or many services.  The test controls the content that is served in an order it controls to the application under test.

See the [wiki](https://github.com/stevenjackson/pinch_hitter/wiki) for more details

See Rakefile for test options

## Standalone

Start the service using rackup

    $ rackup

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Notes

If the `json` gem fails to install on OSX, try running `brew install coreutils`.
