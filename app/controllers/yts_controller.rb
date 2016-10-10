require 'rubygems'
require 'json'
require 'net/http'
require 'ostruct'

class YtsController < ApplicationController
    def index
        @movies = Movie.all.page(params[:page]).per(10)
    end

    def suckyts
        ytsURI = "https://yts.ag/api/v2/list_movies.json?limit=50&page=1"
        response = Net::HTTP.get_response(URI.parse(ytsURI))
        results = JSON.parse(response.body)["data"]["movies"]
        @result = results
        $i = 2
        $num = 117
        while $i < $num  do
            ytsURI = "https://yts.ag/api/v2/list_movies.json?limit=50&page=" + $i.to_s
            response = Net::HTTP.get_response(URI.parse(ytsURI))
            results = JSON.parse(response.body)["data"]["movies"]
            @result = @result | results  
            $i += 1
        end
        
        @result.each do |nyts|
            @movie = Movie.new
            @movie.title = nyts["title"]
            @movie.year = nyts["year"]
            @movie.rating = nyts["rating"]
            @movie.runtime = nyts["runtime"]
            @movie.genres = nyts["genres"]
            @movie.summary = nyts["summary"]
            @movie.language = nyts["language"]
            @movie.poster = nyts["large_cover_image"]
            @movie.background = nyts["background_image"]
            @movie.imdb = nyts["imdb_code"]
            @movie.torrents = nyts["torrents"]
            @movie.save
        end
        
        @value = Movie.count
    end
end
