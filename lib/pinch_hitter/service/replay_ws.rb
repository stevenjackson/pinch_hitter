require 'bundler/setup'
require 'sinatra/base'
require 'nokogiri'
require 'json'

require 'pinch_hitter/service/response_queues'
require 'pinch_hitter/message/content_type'

module PinchHitter
  module Service
    class ReplayWs < Sinatra::Base
      include PinchHitter::Message::ContentType

      configure do
        @@responses = ResponseQueues.new
        #SOAP expects a mime_type of text/xml
        mime_type :xml, "text/xml"
        mime_type :json, "application/json"
      end

      post '/reset' do
        @@responses.reset
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

      post '/store_module' do
        store_module request["endpoint"], request.body.read
        status 200
      end

      post '/respond' do
        respond nil
      end

      get '/*' do
        respond params[:splat].first
      end

      post '/*' do
        respond params[:splat].first
      end

      def store(endpoint='/', message=nil)
        @@responses.store endpoint, message
      end

      def respond(endpoint='/')
        message = @@responses.retrieve endpoint
        content_type determine_content_type message
        puts "No message found for #{endpoint}" unless message
        message
      end

      def store_module(endpoint='/', mod='')
        
      end

    end
  end
end
