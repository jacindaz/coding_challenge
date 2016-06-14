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
register Sinatra::Flash

get '/' do
  haml :index
end

post '/send_text' do
  text_message_body = params[:text_body]

  if params["to_number"] == "" || params["text_body"] == ""
    if params["to_number"] == ""

      flash[:error_number] = "Must fill in a phone number."
    end

    if params["text_body"] == ""
      flash[:error_text] = "Must fill in a text body."
    end

    redirect '/'
  else
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

  redirect '/'
end
