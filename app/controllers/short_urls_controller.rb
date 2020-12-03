class ShortUrlsController < ApplicationController

  def index
    render json: { urls: ShortUrl.top }
  end

  def create
  end

  def show
  end

end
