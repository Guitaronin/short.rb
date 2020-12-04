require 'mechanize'

class ShortUrl < ApplicationRecord

  COLUMNS = %i[full_url title click_count]
  METHODS = %i[short_code]

  validates :full_url, presence: true
  validate :validate_full_url

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
    mechanize = Mechanize.new

    mechanize.get(self[:full_url]) do |page|
      self[:title] = page.title
      save
    end
  end

  def as_json(options = { })
    defaults = { only: COLUMNS, methods: METHODS }
    super(defaults.merge(options))
  end

  def public_attributes
    data = COLUMNS.each_with_object({}) { |attribute, memo| memo[attribute.to_s] = self[attribute] }
    METHODS.each { |method| data[method.to_s] = self.send(method) }

    data
  end

  private

  def validate_full_url
    uri = URI.parse(full_url)

    errors.add(:full_url, 'is not a valid url') unless uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    errors.add(:full_url, 'is not a valid url')
  end
end
