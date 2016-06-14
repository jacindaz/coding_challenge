require 'sinatra/base'
require 'sinatra/flash'

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
    Notifier.new(params[:image_search], params[:to_number], text_message_body).send_sms
  rescue Exception => e
    session[:message] = "Uh oh! Your text could not be sent.\n\nError message: #{e}"
  else
    session[:message] = "Yay! You sent a text with message #{text_message_body}"
    begin
      Notifier.new(params[:image_search], params[:to_number], text_message_body).send_sms
    rescue Exception => e
      flash[:message] = "Uh oh! Your text could not be sent.\n\nError message: #{e}"
    rescue Twilio::REST::RequestError => e
      flash[:message] = "Uh oh! Your text could not be sent.\n\nError message: #{e}"
    else
      flash[:message] = "Yay! You sent a text with message #{text_message_body}"
    end
  end

  haml :index
end
