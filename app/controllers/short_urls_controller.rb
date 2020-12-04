class ShortUrlsController < ApplicationController

  def index
    @urls = ShortUrl.top

    render json: { urls: @urls }
  end

  def create
    @url = ShortUrl.new(short_url_params)

    if @url.save!
      UpdateTitleJob.perform_later(@url.id)
      render json: @url, status: :created
    end
  rescue ActiveRecord::RecordInvalid
    render json: { errors: 'Full url is not a valid url' } , status: :unprocessable_entity
  end

  def show
    @url = ShortUrl.find_by_short_code(params[:id])

    @url.click_count += 1
    @url.save

    redirect_to @url.full_url
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Not Found'}, status: :not_found
  end

  private

  def short_url_params
    params.permit(:full_url)
  end
end
