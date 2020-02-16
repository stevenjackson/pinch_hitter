Given(/^I setup my replay service with no\-cache$/) do
    mock.reset
    mock.no_cache
end

When(/^I make a request$/) do
  mock.prime '/car_rental', :car_rental
  @response = app.post '/car_rental', '{"reservation": "yes"}'
end

Then(/^my response has a no\-cache,no\-store Cache\-Control header$/) do
  expect(@response.header['Cache-Control']).to eq 'no-cache, no-store'
end
