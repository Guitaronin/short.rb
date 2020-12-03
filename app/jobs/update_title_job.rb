require 'mechanize'

class UpdateTitleJob < ApplicationJob
  queue_as :default

  def perform(short_url_id)
    @url = ShortUrl.find(short_url_id)

    mechanize = Mechanize.new

    mechanize.get(@url.full_url) do |page|
      @url.title = page.title
      @url.save
    end
  end
end
