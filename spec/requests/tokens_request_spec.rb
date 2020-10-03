require 'rails_helper'

RSpec.describe 'Api::V1::Tokens', type: :request do
  let(:user) { FactoryBot.create(:user) }
  describe 'POST api/v1/tokens' do
    it 'gets jwt token with valid attributes' do
      post api_v1_tokens_url, params: { user: { email: user.email, password: 'Test1234#' } }, as: :json
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['token']).to_not be_nil
    end

    it 'does not get jwt token with invalid attributes' do
      post api_v1_tokens_url, params: { user: { email: user.email, password: 'blank' } }, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
