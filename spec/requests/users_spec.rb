require 'rails_helper'

RSpec.describe 'POST /api/v1/users', type: :request do

  it 'creates user with valid attributes' do
    user_attributes = FactoryBot.attributes_for(:user)
    expect do
      post api_v1_users_url, params: {
        user: user_attributes
      }, as: :json
    end.to change { User.count }.by(1)
    expect(response).to have_http_status :created
  end

  it 'does not create user when email is taken' do
    other_user = FactoryBot.create(:user)
    user_attributes = FactoryBot.attributes_for(:user, email: other_user.email)
    expect do
      post api_v1_users_url, params: {
        user: user_attributes
      }, as: :json
    end.to_not(change { User.count })
    expect(response).to have_http_status :unprocessable_entity
  end
end
