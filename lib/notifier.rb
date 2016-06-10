require 'twilio-ruby'

module Notifier
  def self.send_sms_notifications(image_search_terms, text_number, text_body = "Text from Twilio")
    twilio_account_sid = ENV['TWILIO_ACCOUNT_SID']
    twilio_auth_token = ENV['TWILIO_AUTH_TOKEN']

    client = Twilio::REST::Client.new twilio_account_sid, twilio_auth_token
    send_sms(client, text_number, text_body, image_search_terms)
  end

  private

  def self.send_sms(client, to_number, text_body, image_search_terms)
    twilio_number = ENV['TWILIO_FROM_NUMBER']

    client.account.messages.create(
      from: twilio_number,
      to: to_number,
      body: text_body,
      media_url: ::Giphy.new.get_image_data(image_search_terms)
    )
  end
end
