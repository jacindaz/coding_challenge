require 'net/http'
require 'json'
require 'open-uri'

class Giphy
  def initialize(search_params)
    @search_params = search_params
    @api_endpoint = 'http://api.giphy.com/v1/gifs/search?q='
  end

  def giphy_image_search_url
    return_image_url(get_image_data)
  end

  def get_image_data
    uri = URI(construct_api_endpoint)
    response = Net::HTTP.get(uri)
    JSON.parse(response)['data']
  end

  private

  def return_image_url(data)
    data.first['images']['downsized_medium']['url']
  end

  def construct_api_endpoint
    # http://api.giphy.com/v1/gifs/search?q=funny+cat&api_key=dc6zaTOxFJmzC
    @api_endpoint + "#{@search_params}&api_key=dc6zaTOxFJmzC"
  end
end
