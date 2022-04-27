require 'sinatra'
require 'sequel'

configure do
  set port: 3000
end

get '/' do
  'Hello world!'
end

def db
  Sequel.connect(
    host: ENV['DB_HOST'],
    database: ENV['DB_NAME'],
    user: ENV['DB_USER'],
    password: ENV['DB_PASSWORD'],
    adapter: ENV['DB_ADAPTER']
  )
end