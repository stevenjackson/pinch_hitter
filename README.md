# Pinch Hitter
Simple replay mock for web service testing

## Installation

Add this line to your application's Gemfile:

    gem 'pinch_hitter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pinch_hitter

## Usage

Any xml posted to the /store endpoint will be returned (FIFO) when a post to the /respond endpoint is made.

Start the service using rackup
  rackup

See Rakefile for test options

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
