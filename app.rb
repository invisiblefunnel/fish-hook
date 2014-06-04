require 'dotenv'
Dotenv.load

require './db'
require 'json'
require 'sinatra'

if ENV['BASIC_AUTH_NAME'] && ENV['BASIC_AUTH_PASSWORD']
  use Rack::Auth::Basic, 'Restricted Area' do |name, password|
    name == ENV['BASIC_AUTH_NAME'] && password == ENV['BASIC_AUTH_PASSWORD']
  end
end

post '/hooks/:subscriber_id' do
  subscriber_id = params.delete(:subscriber_id)
  DB[:hooks].insert(subscriber_id: subscriber_id, payload: params.to_json)
  200
end
