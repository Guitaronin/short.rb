class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  scope :top, ->(top = 100) { limit(top).order(click_count: :desc) }

  validate :validate_full_url

  def short_code
  end

  def update_title!
  end

  private

  def validate_full_url
  end

end
