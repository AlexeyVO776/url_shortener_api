require 'rails_helper'

RSpec.describe Api::UrlsController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new url' do
        expect {
          post :create, params: { url: { original_url: 'http://example.com' } }
        }.to change(Api::Url, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: { url: { original_url: 'http://example.com' } }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new url' do
        expect {
          post :create, params: { url: { original_url: nil } }
        }.not_to change(Api::Url, :count)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: { url: { original_url: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #show' do
    let!(:url) do
      url = Api::Url.new(original_url: 'http://example.com')
      url.generate_short_url
      url.save!
      url
      end


    it 'returns the original url' do
      get :show, params: { short_url: url.short_url }
      expect(response).to have_http_status(:ok)
      expect(json_response['original_url']).to eq('http://example.com')
    end

    it 'increments the click count' do
      expect {
        get :show, params: { short_url: url.short_url }
      }.to change { url.reload.click_count }.by(1)
    end
  end

  describe 'GET #stats' do
    let!(:url) do
      url = Api::Url.new(original_url: 'http://example.com', click_count: 5)
      url.generate_short_url
      url.save!
      url
    end

    it 'returns the click count' do
      get :stats, params: { short_url: url.short_url }
      expect(response).to have_http_status(:ok)
      expect(json_response['click_count']).to eq(5)
    end
  end
end