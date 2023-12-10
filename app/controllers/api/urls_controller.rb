module Api
  class UrlsController < ApplicationController
    # POST /api/urls
    def create
      @url = Api::Url.new(url_params)

      @url.generate_short_url

      if @url.save
        render json: { short_url: api_short_url(@url.short_url) }, status: :created
      else
        render json: @url.errors, status: :unprocessable_entity
      end
    end

    # GET /api/urls/:short_url
    def show
      @url = Api::Url.find_by!(short_url: params[:short_url])
      @url.increment!(:click_count)
      render json: { original_url: @url.original_url }
    end

    # GET /api/urls/:short_url/stats
    def stats
      @url = Api::Url.find_by!(short_url: params[:short_url])
      render json: { click_count: @url.click_count }
    end

    private

    def url_params
      params.require(:url).permit(:original_url)
    end
  end
end
