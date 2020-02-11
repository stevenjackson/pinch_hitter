require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/cross_origin'
require 'json'

require 'pinch_hitter/service/endpoint_handlers'
require 'pinch_hitter/service/endpoint_recorders'
require 'pinch_hitter/message/content_type'

module PinchHitter::Service
  class ReplayWs < Sinatra::Base
    include PinchHitter::Message::ContentType

    register Sinatra::CrossOrigin

    configure do
      enable :cross_origin
      @@handlers = EndpointHandlers.new
      @@recorder = EndpointRecorders.new
      #SOAP expects a mime_type of text/xml
      mime_type :xml, "text/xml"
      mime_type :json, "application/json"
      disable :no_cache
    end


    before do
      cache_control :no_cache, :no_store if settings.no_cache
    end

    post '/reset' do
      @@handlers.reset
      @@recorder.reset
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
      respond params[:splat].first, request
    end

    delete '/*' do
      respond params[:splat].first, request
    end

    post '/*' do
      respond params[:splat].first, request
    end

    put '/*' do
      respond params[:splat].first, request
    end

    patch '/*' do
      respond params[:splat].first, request
    end

    def store(endpoint='/', message=nil)
      endpoint = normalize(endpoint)
      @@handlers.store_message endpoint, message
    end

    def respond(endpoint='/', request=nil)
      endpoint = normalize(endpoint)
      body, request = wrap(request)
      @@recorder.record(endpoint, request)
      if @@handlers.handler_for?(endpoint)
        message = @@handlers.respond_to(endpoint, body, request, response)
        if message
          content_type determine_content_type message
          message
        else
          status 404
        end
      else
        status 404
      end
    end

    def register_module(endpoint='/', mod='')
      endpoint = normalize(endpoint)
      @@handlers.register_module endpoint, Marshal.load(mod)
    end

    def requests endpoint
      endpoint = normalize(endpoint)
      content_type 'application/json'
      { requests: @@recorder.requests(endpoint) }.to_json
    end

    def wrap(request)
      return [nil, nil] unless request

      body = request.body.read
      [body, { headers: request_headers, body: body }]
    end

    def request_headers
      env.select { |key, value| key.upcase == key }
    end

    def normalize(endpoint)
      return endpoint if endpoint =~ /^\//
      "/#{endpoint}"
    end

  end
end
