# Encoding and decoding reference
# https://github.com/delight-im/ShortURL/commit/1044df79aebdabe437b269552bb9ed80df2c28e3
class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze
  BASE = CHARACTERS.length

  validates :full_url, presence: true
  validate :validate_full_url

  scope :top, ->(top = 100) { limit(top).order(click_count: :desc) }
  scope :find_by_short_code, lambda { |short_code|
    return if short_code.nil?

    short_code = short_code.to_s
    id = x = 0

    while x < short_code.length do
      id = id * BASE + CHARACTERS.index(short_code[x])
      x += 1
    end

    find(id)
  }

  def short_code
    return if self[:id].nil?

    encode(self[:id])
  end

  def update_title!
  end

  def as_json(options = { })
    super(options.merge({ :methods => [:short_code ], except: [:created_at, :updated_at ] }))
  end

  def public_attributes
    %w[id full_url title click_count short_code]
  end

  private

  def validate_full_url
    uri = URI.parse(full_url)

    errors.add(:full_url, 'is not a valid url') unless uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    errors.add(:full_url, 'is not a valid url')
  end

  # https://github.com/delight-im/ShortURL/commit/1044df79aebdabe437b269552bb9ed80df2c28e3
  def encode(id)
    short_code = ""

    while id > 0 do
      short_code = CHARACTERS[id % BASE] + short_code
      id /= BASE
    end

    short_code
  end

  # https://github.com/delight-im/ShortURL/commit/1044df79aebdabe437b269552bb9ed80df2c28e3
  def decode(short_code)
    short_code = short_code.to_s
    id = x = 0

    while x < short_code.length do
      id = id * BASE + CHARACTERS.index(short_code[x])
      x += 1
    end

    id
  end
end
