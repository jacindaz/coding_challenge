require 'sinatra'
require 'sinatra/flash'

require 'net/http'
require 'json'
require 'open-uri'

ENV['RACK_ENV'] ||= 'development'
if ENV['RACK_ENV'] == 'development'
  require 'dotenv'
  Dotenv.load
  require 'pry'
end

require_relative './lib/notifier'
require_relative './lib/giphy'


require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

use Rack::Session::Cookie, :expire_after => 2 # In seconds
register Sinatra::Flash

get '/' do
  haml :index
end

post '/send_text' do
  text_message_body = params[:text_body]
  image_search_terms = params[:image_search]
  text_to_number = params[:to_number]

  if text_to_number == "" || text_message_body == ""
    if text_to_number == ""

      flash[:error_number] = "Must fill in a phone number."
    end

    if text_message_body == ""
      flash[:error_text] = "Must fill in a text body."
    end

    redirect '/'
  else
    begin
      Notifier.new(image_search_terms, text_to_number, text_message_body).send_sms
    rescue Exception => e
      flash[:message] = "Uh oh! Your text could not be sent.\n\nError message: #{e}"
    rescue Twilio::REST::RequestError => e
      flash[:message] = "Uh oh! Your text could not be sent.\n\nError message: #{e}"
    else
      message = "Yay! You sent a text with message #{text_message_body}"

      if image_search_terms
        message += ", and used these image search terms: #{image_search_terms}"
      end

      flash[:message] = message
    end
  end

  redirect '/'
end
