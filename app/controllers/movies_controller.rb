class MoviesController < ApplicationController
    
    def index
        params.permit(:year, :genre, :rating, :quality, :page)
        ytsBaseURI = "https://yts.ag/api/v2/list_movies.json"
        
        limitKey = "?limit=" + "50"
        
        pageKey, yearKey, qualityKey, genreKey, ratingKey = ""
        if params[:page]
            pageKey = "&page=" + params[:page]
            @current_page = params[:page].to_i
        else
            pageKey = ""
            @current_page = 1
        end
        if params[:year] != ""
            yearKey = "&query_term=" + params[:year].to_s
        else
            yearKey = ""
        end
        if params[:quality] != ""
            qualityKey = "&quality=" + params[:quality].to_s
        else
            qualityKey = ""
        end
        if params[:genre] != ""
            genreKey = "&genre=" + params[:genre].to_s
        else
            genreKey = ""
        end
        if params[:rating] != ""
            ratingKey = "&minimum_rating=" + params[:rating].to_s
        else
            ratingKey = ""
        end
        
        queryKey = "&query_term="
        sortKey = "&sort_by="
        orderKey = "&order_by="
        
        ytsURI = ytsBaseURI + limitKey + yearKey + qualityKey + genreKey + ratingKey + pageKey
        response = Net::HTTP.get_response(URI.parse(ytsURI))
        result = JSON.parse(response.body)
        page_count = result["data"]["movie_count"].to_i / result["data"]["limit"].to_i + 1
        @last_page = page_count
        @uri = ytsURI
        @movies = result["data"]["movies"]
    end

    def suckyts
        
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
