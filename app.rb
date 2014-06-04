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
  DB[:hooks].insert(subscriber_id: params[:subscriber_id], payload: request.body.read)
  200
end
