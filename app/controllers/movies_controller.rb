class MoviesController < ApplicationController
    def index
        uris
        filters
        params.permit(:year, :genre, :rating, :quality, :page, :q, :id, :sort, :order)
        limit_key = "?limit=" + "20"
        
        if params[:page] && params[:page] != ""
            page_key = "&page=" + params[:page]
            @current_page = params[:page].to_i
        else
            page_key = "&page=1"
            @current_page = 1
        end
        if params[:year] && params[:year] != ""
            year_key = "&query_term=" + params[:year].to_s
        else
            year_key = ""
        end
        if params[:quality] && params[:quality] != ""
            quality_key = "&quality=" + params[:quality].to_s
        else
            quality_key = ""
        end
        if params[:genre] && params[:genre] != ""
            genre_key = "&genre=" + params[:genre].to_s
        else
            genre_key = ""
        end
        if params[:rating] && params[:rating] != ""
            rating_key = "&minimum_rating=" + params[:rating].to_s
        else
            rating_key = ""
        end
        if params[:q] && params[:q] != ""
            query_key = "&query_term=" + params[:q].to_s
        else
            query_key = ""
        end
        if params[:sort] && params[:sort] != ""
            if params[:sort] == "rating"
                sort_key = "&sort_by=" + params[:sort].to_s + "&order_by=desc"
            end
            if params[:sort] == "year"
                sort_key = "&sort_by=" + params[:sort].to_s + "&order_by=desc"
            end
            if params[:sort] == "title"
                sort_key = "&sort_by=" + params[:sort].to_s + "&order_by=asc"
            end
        else
            sort_key = "&sort_by=date_added&order_by=desc"
        end
        if params[:order] && params[:order] != ""
            order_key = "&order_by=" + params[:order].to_s
        else
            order_key = ""
        end
        
        yts_list_URI = @yts_base_URI + @yts_list_req + limit_key + year_key + quality_key + genre_key + rating_key + page_key + query_key + sort_key
        yts_list_response = Net::HTTP.get_response(URI.parse(yts_list_URI))
        yts_list_result = JSON.parse(yts_list_response.body)
        page_count = yts_list_result["data"]["movie_count"].to_i / yts_list_result["data"]["limit"].to_i + 1
        @last_page = page_count
        @list_status = yts_list_result["status"]
        @list_status_message = yts_list_result["status_message"]
        @movies = yts_list_result["data"]["movies"]
    end
    
    def show        
        uris
        yts_movie_URI = @yts_base_URI + @yts_movie_req + params[:id]
        yts_movie_response = Net::HTTP.get_response(URI.parse(yts_movie_URI))
        yts_movie_result = JSON.parse(yts_movie_response.body)
        @movie_status = yts_movie_result["status"]
        @movie_status_message = yts_movie_result["status_message"]
        @movie = yts_movie_result["data"]["movie"]
        yts_suggestions_URI = @yts_base_URI + @yts_suggestions_req + params[:id]
        yts_suggestions_response = Net::HTTP.get_response(URI.parse(yts_suggestions_URI))
        yts_suggestions_result = JSON.parse(yts_suggestions_response.body)
        @suggestions_status = yts_suggestions_result["status"]
        @suggestions_status_message = yts_suggestions_result["status_message"]
        @suggestions = yts_suggestions_result["data"]["movies"]
    end
    
    private
    def uris
        @yts_base_URI = "https://yts.ag/api/v2/"
        @yts_list_req = "list_movies.json"
        @yts_suggestions_req = "movie_suggestions.json?movie_id="
        @yts_movie_req = "movie_details.json?with_images=true&with_cast=true&movie_id="
    end
    def filters
        @sorts = [
            "rating",
            "year",
            "title"
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
            "Animation",
            "Biography",
            "Comedy",
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
            "1"
            ]
        @min_year = 1918
        @max_year = 2016
    end
end
