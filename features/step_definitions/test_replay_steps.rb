Given /^I setup my replay service$/ do
  mock.reset
end

Given /^I want a car rental$/ do
  mock.prime '/car_rental', :car_rental
end

When /^I make a reservation$/ do
  @response = app.post '/car_rental', ''
end

Then /^I see a car reservation$/ do
  @response.body.to_s.should == messages.load(:car_rental).squish
end

Given /^I want a car rental with a "(.*?)" of "(.*?)"$/ do |tag, text|
  mock.prime '/car_rental', :car_rental, tag => text
end

Then /^I see a car reservation with a "(.*?)" of "(.*?)"$/ do |tag, text|
  @response.body.to_s.should == messages.load(:car_rental, { tag => text }).squish
end

Given /^I want to lookup a definition$/ do
  mock.prime '/glossary', :glossary
end

When /^I query the glossary$/ do
  @response = app.get "/glossary?term=SGML"
end

Then /^I see a definition$/ do
  @response.body.to_s.should == messages.load(:glossary).squish
end

Given /^I want to lookup a definition with a "(.*?)" of "(.*?)"$/ do |key, value|
  mock.prime '/glossary', :glossary, key => value
end

Then /^I see a definition with a "(.*?)" of "(.*?)"$/ do |key, value|
  @response.body.to_s.should == messages.load(:glossary, { key => value }).squish
end

Given(/^I want to do some fancy processing$/) do
  mock.register_module('/service', XmlParser)
end

When(/^I query my service with (.*?)$/) do |request|
  @response = app.post '/service', "<request>#{request}</request>"
end

Then(/^I see (.*?) in the service response$/) do |response|
  @response.body.to_s.should == "<response>#{response}</response>"
end
