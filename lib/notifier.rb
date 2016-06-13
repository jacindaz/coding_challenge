require 'twilio-ruby'
require 'pry'
require_relative 'giphy'

class Notifier
  def initialize(image_search_terms, to_number, text_body)
    @image_search_terms = image_search_terms
    @text_body = text_body || "A text from Twilio"

    @from_number = ENV['TWILIO_FROM_NUMBER']
    @to_number = to_number
  end

  def send_sms
    begin
      twilio_api_client.account.messages.create(twilio_message)
    rescue Twilio::REST::RequestError => e
      e.message
    rescue Exception => e
      e.message
    end
  end

  private

  def twilio_message
    {
      from: @from_number,
      to: @to_number,
      body: @text_body,
      media_url: giphy_image_url
    }
  end

  def giphy_image_url
    ::Giphy.new(@image_search_terms).giphy_image_search_url
  end

  def twilio_api_client
    Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end
end
