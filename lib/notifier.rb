require 'yaml'
require 'twilio-ruby'

module Notifier
  def self.send_sms_notifications(text_number, text_body = "Text from Twilio")
    twilio_account_sid = ENV['TWILIO_ACCOUNT_SID']
    twilio_auth_token = ENV['TWILIO_AUTH_TOKEN']

    client = Twilio::REST::Client.new twilio_account_sid, twilio_auth_token
    send_sms(client, text_number, text_body)
  end

  private

  def self.send_sms(client, to_number, text_body, image_url = nil)
    twilio_number = ENV['TWILIO_FROM_NUMBER']

    client.account.messages.create(
      from: twilio_number,
      to: to_number,
      body: text_body
      # media_url: image_url
    )
  end
end
