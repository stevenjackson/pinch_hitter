Given /^I setup my capture service$/ do
  mock.reset
end

When /^I make (\d+) posts$/ do |number|
  number.to_i.times.each do
    app.post '/test_post', '{"reservation": "yes"}'
  end
end

Then /^the service has received (\d+) posts(?:s?)$/ do |number|
  expect(mock.request_log('/test_post').count).to eq number.to_i
end

When /^I do a (.*?) on "(.*?)"$/ do |method, endpoint|
  app.send method.downcase, endpoint, '{"payload": "2tons"}'
end

Then(/^the service has recieved a request on "(.*?)"$/) do |endpoint|
  expect(mock.request_log(endpoint).count).to be > 0
end

When /^the headers for the request on "(.*?)" should contain:$/ do |endpoint, table|
  headers = mock.request_log(endpoint).first.headers
  table.rows_hash.each do |key, value|
    expect(headers[key]).to eq value
  end
end
