require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new url' do
        expect {
          post :create, params: { url: { original_url: 'http://example.com' } }
        }.to change(Url, :count).by(1)
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
        }.not_to change(Url, :count)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: { url: { original_url: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end