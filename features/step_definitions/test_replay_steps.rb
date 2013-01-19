require 'net/http'
require 'pinch_hitter/message/message_store'

def http
  @http ||= Net::HTTP.new '127.0.0.1', 9292
end

def messages
  @messages ||= PinchHitter::Message::MessageStore.new File.join(File.dirname('.'), 'features', 'messages')
end

Given /^I setup my replay service$/ do
  http.post "/reset", ''
end

Given /^I want a car rental$/ do
 http.post "/store/car_rental", messages.load(:car_rental)
end

When /^I make a reservation$/ do
  @response = http.post '/car_rental', ''
end

Then /^I see a car reservation$/ do
  @response.body.to_s.should == messages.load(:car_rental).squish
end

Given /^I want a car rental with a "(.*?)" of "(.*?)"$/ do |tag, text|
  http.post "/store/car_rental", messages.load(:car_rental, { tag => text })
end

Then /^I see a car reservation with a "(.*?)" of "(.*?)"$/ do |tag, text|
  @response.body.to_s.should == messages.load(:car_rental, { tag => text }).squish
end

Given /^I want to lookup a definition$/ do
  http.post "/store?endpoint=glossary", messages.load(:glossary)
end

When /^I query the glossary$/ do
  @response = http.get "/glossary?term=SGML"
end

Then /^I see a definition$/ do
  @response.body.to_s.should == messages.load(:glossary).squish
end
