require 'sinatra/base'
# require 'dotenv'
# Dotenv.load

require_relative './lib/notifier'

ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym


get '/' do
  haml :index
  Notifier.send_sms_notifications
end
