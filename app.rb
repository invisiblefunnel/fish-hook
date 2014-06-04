require 'dotenv'
Dotenv.load

require 'json'
require 'sequel'
require 'sinatra'

DB = Sequel.connect(ENV.fetch('DATABASE_URL'))

DB.create_table?(:hooks) do
  primary_key :id
  Integer :subscriber_id, index: true
  String :payload
  DateTime :created_at
end

if ENV['BASIC_AUTH_NAME'] && ENV['BASIC_AUTH_PASSWORD']
  use Rack::Auth::Basic, 'Restricted Area' do |name, password|
    name == ENV['BASIC_AUTH_NAME'] && password == ENV['BASIC_AUTH_PASSWORD']
  end
end

get '/' do
  @hooks = DB[:hooks].limit(500)
  erb :index
end

post '/hooks/:subscriber_id' do
  DB[:hooks].insert(subscriber_id: params[:subscriber_id], payload: request.body.read, created_at: DateTime.now)
  200
end
