require 'sinatra/base'
require 'minitest/autorun'
require 'rack/test'

require_relative '../myapp'

class MyAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_my_default
    get '/'

    assert_includes(last_response.body, "PLM Coding Challenge")
  end
end
