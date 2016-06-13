require 'sinatra/base'

require 'net/http'
require 'json'
require 'open-uri'
require 'pry'

require 'dotenv'
Dotenv.load

require_relative './lib/notifier'
require_relative './lib/giphy'

ENV['RACK_ENV'] ||= 'development'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

use Rack::Session::Cookie, :expire_after => 2 # In seconds

get '/' do
  haml :index
end

post '/send_text' do
  text_message_body = params[:text_body]

  begin
    Notifier.send_sms_notifications(params[:image_search], params[:text_number], text_message_body)
  rescue Exception => e
    session[:message] = "Uh oh! Your text could not be sent.\n\nError message: #{e}"
  else
    session[:message] = "Yay! You sent a text with message #{text_message_body}"
  end

  haml :index
end
