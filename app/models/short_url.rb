# Encoding and decoding reference
# https://github.com/delight-im/ShortURL/commit/1044df79aebdabe437b269552bb9ed80df2c28e3
class ShortUrl < ApplicationRecord

  validates :full_url, presence: true
  validate :validate_full_url

  after_create :update_title!

  scope :top, ->(top = 100) { limit(top).order(click_count: :desc) }
  scope :find_by_short_code, lambda { |short_code|
    return if short_code.nil?

    id = ShortCodeUtil.decode(short_code)

    find(id)
  }

  def short_code
    return if self[:id].nil?

    ShortCodeUtil.encode(self[:id])
  end

  def update_title!
    UpdateTitleJob.perform_later(self[:id])
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
end
