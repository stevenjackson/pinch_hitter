require 'bundler/setup'
require 'sinatra/base'
require 'nokogiri'
require 'json'

require 'pinch_hitter/service/endpoint_handlers'
require 'pinch_hitter/message/content_type'

module PinchHitter::Service
  class ReplayWs < Sinatra::Base
    include PinchHitter::Message::ContentType

    configure do
      @@handlers = EndpointHandlers.new
      #SOAP expects a mime_type of text/xml
      mime_type :xml, "text/xml"
      mime_type :json, "application/json"
    end

    post '/reset' do
      @@handlers.reset
      status 200
    end

    post '/store/*' do
      store "/#{params[:splat].first}", request.body.read
      status 200
    end

    post '/store' do
      store request["endpoint"], request.body.read
      status 200
    end

    post '/register_module' do
      register_module request["endpoint"], request.body.read
      status 200
    end

    get '/received_requests' do
      requests request["endpoint"]
    end

    post '/respond' do
      respond nil
    end

    get '/*' do
      respond params[:splat].first
    end

    delete '/*' do
      respond params[:splat].first
    end

    post '/*' do
      respond params[:splat].first, request.body.read
    end

    put '/*' do
      respond params[:splat].first, request.body.read
    end

    patch '/*' do
      respond params[:splat].first, request.body.read
    end

    def store(endpoint='/', message=nil)
      @@handlers.store_message endpoint, message
    end

    def respond(endpoint='/', request=nil)
      message = @@handlers.respond_to endpoint, request
      content_type determine_content_type message
      puts "No message found for #{endpoint}" unless message
      message
    end

    def register_module(endpoint='/', mod='')
      @@handlers.register_module endpoint, Marshal.load(mod)
    end

    def requests endpoint
      content_type 'application/json'
      { requests: @@handlers.requests(endpoint) }.to_json
    end

  end
end
