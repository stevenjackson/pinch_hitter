# Pinch Hitter
Simple replay mock for web service testing

## Installation

Add this line to your application's Gemfile:

    gem 'pinch_hitter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pinch_hitter

## Purpose

Simulate those pesky external web services for testing and gain control over the data that's returned.  Pinch Hitter stands in for one or many services, it expects the test to tell it what to serve up to the application under test.

Any xml or json posted to the /store endpoint will be returned in FIFO order with the corresponding endpoint is called.

    For instance, a POST to /store/user will be returned when a GET or POST to /user is called.
    Or a POST to /store?endpoint=user will prime the /user endpoint in the same way.

Multiple endpoints can be stored, each endpoint has it's own FIFO queue.  Once a message is served, it's gone and must be primed again.

See the [wiki](https://github.com/stevenjackson/pinch_hitter/wiki) for more details

See Rakefile for test options

## Standalone

Start the service using rackup
  rackup

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
