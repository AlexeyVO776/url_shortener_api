require 'rails_helper'

RSpec.describe Url, type: :model do
  it 'is invalid without an original_url' do
    url = Url.new(original_url: nil)
    expect(url).not_to be_valid
    expect(url.errors[:original_url]).to include("can't be blank")
  end

  it 'is invalid with a duplicate short_url' do
    Url.create!(original_url: 'http://example.com', short_url: 'abc123')
    duplicate_url = Url.new(original_url: 'http://example.org', short_url: 'abc123')
    expect(duplicate_url).not_to be_valid
    expect(duplicate_url.errors[:short_url]).to include('has already been taken')
  end
end