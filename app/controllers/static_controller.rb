class StaticController < ApplicationController
    def show
        render params[:p]
    end
end
