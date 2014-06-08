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

auth_name = ENV['BASIC_AUTH_NAME']
auth_password = ENV['BASIC_AUTH_PASSWORD']

if auth_name && auth_password
  use Rack::Auth::Basic, 'Restricted Area' do |name, password|
    name == auth_name && password == auth_password
  end
end

get '/' do
  content_type :json
  JSON.pretty_generate DB[:hooks].order(Sequel.desc(:created_at)).limit(100).all
end

post '/hooks/:subscriber_id' do
  DB[:hooks].insert(subscriber_id: params[:subscriber_id], payload: request.body.read, created_at: DateTime.now)
  200
end
