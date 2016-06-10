require 'net/http'
require 'json'
require 'open-uri'

class Giphy
  def initialize
    @api_endpoint = 'http://api.giphy.com/v1/gifs/search?q='
  end

  def get_image_data(search_params)
    uri = URI(construct_api_endpoint(search_params))
    response = Net::HTTP.get(uri)
    JSON.parse(response)['data'].first['url']
  end

  private

  def construct_api_endpoint(search_params)
    # http://api.giphy.com/v1/gifs/search?q=funny+cat&api_key=dc6zaTOxFJmzC
    @api_endpoint + 'search_params' + "&api_key=dc6zaTOxFJmzC"
  end
end
