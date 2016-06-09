require 'sinatra/base'
require 'dotenv'
Dotenv.load

require_relative './lib/notifier'

ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

enable :sessions

get '/' do
  haml :index
end

post '/send_text' do
  text_message_body = params[:text_body]
  Notifier.send_sms_notifications(text_message_body)
  session[:message] = "Yay! You sent a text with message #{text_message_body}"

  render :index
end
