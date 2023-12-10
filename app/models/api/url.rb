module Api
  class Url < ApplicationRecord
    validates :original_url, presence: true, url: { no_local: true, public_suffix: true }
    validates :short_url, uniqueness: true, allow_blank: true
    before_create :set_default_click_count

    def generate_short_url
      loop do
        self.short_url = SecureRandom.urlsafe_base64(6)
        break unless Url.exists?(short_url: self.short_url)
      end
    end

    private

    def set_default_click_count
      self.click_count ||= 0
    end
  end
end