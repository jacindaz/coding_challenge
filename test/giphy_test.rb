require 'minitest/autorun'

require_relative '../lib/giphy'

class MyAppTest < Minitest::Test
  def setup
    @giphy = Giphy.new("I like turtles.")
  end

  def test_get_image_data
    assert_equal @giphy.get_image_data.class, Array
  end

  def test_return_image_url
    data = @giphy.get_image_data
    image_url = @giphy.send(:return_image_url, data)

    assert_includes image_url, "giphy.com/media/", "The Giphy API should return a gif url."
  end

  def test_construct_api_endpoint
    assert_includes @giphy.send(:construct_api_endpoint), "&api_key=", "The api endpoint url should include the api key."
  end
end
