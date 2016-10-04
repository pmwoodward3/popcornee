require 'rubygems'
require 'json'
require 'net/http'
require 'ostruct'

class OmdbController < ApplicationController
    $omdbBaseURI = "http://www.omdbapi.com/?y=&plot=short&r=json&s="
    def index
        if params[:q]
            query = params[:q].parameterize('+')
            
            omdbURI1 = $omdbBaseURI + query
            omdbURI2 = $omdbBaseURI + query + "&page=2"
            omdbURI3 = $omdbBaseURI + query + "&page=3"
            omdbURI4 = $omdbBaseURI + query + "&page=4"
            
            response1 = Net::HTTP.get_response(URI.parse(omdbURI1))
            response2 = Net::HTTP.get_response(URI.parse(omdbURI2))
            response3 = Net::HTTP.get_response(URI.parse(omdbURI3))
            response4 = Net::HTTP.get_response(URI.parse(omdbURI4))
            
            result1 = JSON.parse(response1.body)["Search"]
            result2 = JSON.parse(response2.body)["Search"]
            result3 = JSON.parse(response3.body)["Search"]
            result4 = JSON.parse(response4.body)["Search"]
            
            results = result1
            if result2
                results = result1 | result2
                if result3
                    results = results | result3
                end
                    if result4
                        results = results | result4
                    end
            end
            if results
                @result = results.uniq
            end
        end
    end
end
