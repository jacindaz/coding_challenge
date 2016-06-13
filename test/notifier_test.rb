require 'sinatra/base'
require 'minitest/autorun'

require_relative '../lib/notifier'

class MyAppTest < Minitest::Test
  def setup
    image_search_terms = "Hello, world"
    text_number = '1234567890'
    text_body = "Hi!"

    @notifier = Notifier.new(image_search_terms, text_number, text_body)
  end

  def test_giphy_image_url
    image_url = @notifier.send(:giphy_image_url)

    assert_includes image_url, "http://media2.giphy.com/media/"
  end

  def test_twilio_message
    twilio_message_hash = @notifier.send(:twilio_message)

    assert_equal twilio_message_hash.keys.sort, [:body, :from, :media_url, :to]
  end
end
