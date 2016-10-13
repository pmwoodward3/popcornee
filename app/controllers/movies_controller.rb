class MoviesController < ApplicationController
    def index
        params.permit(:year, :genre, :rating, :quality, :page, :q, :id, :sort, :order)
        ytsBaseURI = "https://yts.ag/api/v2/list_movies.json"
        
        limitKey = "?limit=" + "20"
        
        queryKey, sortKey, orderKey, pageKey, yearKey, qualityKey, genreKey, ratingKey = ""
        
        if params[:page]
            pageKey = "&page=" + params[:page]
            @current_page = params[:page].to_i
        else
            pageKey = ""
            @current_page = 1
        end
        if params[:year]
            yearKey = "&query_term=" + params[:year].to_s
        else
            yearKey = ""
        end
        if params[:quality]
            qualityKey = "&quality=" + params[:quality].to_s
        else
            qualityKey = ""
        end
        if params[:genre]
            genreKey = "&genre=" + params[:genre].to_s
        else
            genreKey = ""
        end
        if params[:rating]
            ratingKey = "&minimum_rating=" + params[:rating].to_s
        else
            ratingKey = ""
        end
        if params[:q]
            queryKey = "&query_term=" + params[:q].to_s
        else
            queryKey = ""
        end
        if params[:sort]
            sortKey = "&sort_by=" + params[:sort].to_s
        else
            sortKey = ""
        end
        if params[:order]
            orderKey = "&order_by=" + params[:order].to_s
        else
            orderKey = ""
        end

        ytsURI = ytsBaseURI + limitKey + yearKey + qualityKey + genreKey + ratingKey + pageKey + queryKey + sortKey + orderKey
        response = Net::HTTP.get_response(URI.parse(ytsURI))
        result = JSON.parse(response.body)
        page_count = result["data"]["movie_count"].to_i / result["data"]["limit"].to_i + 1
        @last_page = page_count
        @uri = ytsURI
        @movies = result["data"]["movies"]
        @sorts = [
            "rating",
            "year",
            "title",
            ]
        @orders = [
            "ASC",
            "DESC"
            ]
        @qualities = [
            "720p",
            "1080p",
            "3D"
            ]
        @genres = [
            "Action",
            "Adventure",
            "Biography",
            "Comdey",
            "Crime",
            "Documentary",
            "Drama",
            "Family",
            "Fantasy",
            "Film-Noir",
            "History",
            "Horror",
            "Music",
            "Musical",
            "Mystery",
            "Romance",
            "Sci-Fi",
            "Sport",
            "Thriller",
            "War",
            "Western"
            ]
        @ratings = [
            "9",
            "8",
            "7",
            "6",
            "5",
            "4",
            "3",
            "2",
            "1",
            ]
        @min_year = 1918
        @max_year = 2016
    end
    
    def show
        ytsBaseURI = "https://yts.ag/api/v2/movie_details.json?with_images=true&with_cast=true&movie_id="
        ytsURI = ytsBaseURI = ytsBaseURI + params[:id]
        response = Net::HTTP.get_response(URI.parse(ytsURI))
        result = JSON.parse(response.body)
        @movie = result["data"]["movie"]
    end
end
