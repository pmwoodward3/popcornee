require 'rubygems'
require 'json'
require 'net/http'
require 'ostruct'

class YtsController < ApplicationController
    $ytsBaseURI = "https://yts.ag/api/v2/list_movies.json?limit=50"
    def extractor
        if params[:q]
            query = "&query_term=" + params[:q].parameterize('+')
            ytsURI = $ytsBaseURI + query
        else
            ytsURI = $ytsBaseURI + "&query_term=2016"
        end
        response = Net::HTTP.get_response(URI.parse(ytsURI))

        results = JSON.parse(response.body)["data"]["movies"]
        if results
            @result = results.uniq
        end
    end
end
