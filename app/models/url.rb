class Url < ApplicationRecord
  validates :original_url, presence: true, url: { no_local: true, public_suffix: true }
  validates :short_url, uniqueness: true, presence: true
end
