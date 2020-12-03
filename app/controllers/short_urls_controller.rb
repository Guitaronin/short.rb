class ShortUrlsController < ApplicationController

  def index
    render json: { urls: ShortUrl.top }
  end

  def create
    @url = ShortUrl.new(short_url_params)

    if @url.save!
      render json: @url, status: :created
    end
  rescue ActiveRecord::RecordInvalid
    render json: { errors: 'Full url is not a valid url' } , status: :unprocessable_entity
  end

  def show
  end

  private

  def short_url_params
    params.permit(:full_url)
  end
end
