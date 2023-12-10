class UrlsController < ApplicationController
  # POST /urls
  def create
    @url = Url.new(url_params)

    loop do
      @url.short_url = SecureRandom.urlsafe_base64(6)
      break unless Url.exists?(short_url: @url.short_url)
    end

    if @url.save
      render json: { short_url: url_for(short_path(@url.short_url)) }, status: :created
    else
      render json: @url.errors, status: :unprocessable_entity
    end
  end

  # GET /urls/:short_url
  def show
    @url = Url.find_by!(short_url: params[:short_url])
    @url.increment!(:click_count)
    redirect_to @url.original_url, allow_other_host: true
  end

  # GET /urls/:short_url/stats
  def stats
    @url = Url.find_by!(short_url: params[:short_url])
    render json: { click_count: @url.click_count }
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end
end
