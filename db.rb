require 'sequel'

DB = Sequel.connect(ENV.fetch('DATABASE_URL'))

DB.create_table?(:hooks) do
  primary_key :id
  Integer :subscriber_id, index: true
  String :payload
end
