libdir = File.dirname(__FILE__) + '/lib'
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include? libdir

require 'pinch_hitter/service/replay_ws'
require 'logger'

class ::Logger; alias_method :write, :<<; end
logger = Logger.new('app.log')
use Rack::CommonLogger, logger

run PinchHitter::Service::ReplayWs
