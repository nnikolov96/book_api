require 'rails_helper'

RSpec.describe "POST api/v1/books", type: :request do
  let(:admin_user) { FactoryBot.create(:user, :admin) }
  let(:user) { FactoryBot.create(:user) }

  before do
    @book_attributes = FactoryBot.attributes_for(:book)
  end
  context 'when admin' do
    it 'creates book with valid attributes' do
      expect do
        post api_v1_books_url, params: {
          book: @book_attributes
        },
        headers: {
          Authorization: JsonWebToken.encode(user_id: admin_user.id)
        }, as: :json
      end.to change { Book.count }.by(1)
      expect(response).to have_http_status :created
    end
    it 'does not create book with invalid attributes' do
      expect do
        post api_v1_books_url, params: {
          book: { title: '', isbn: '', description: ''}
        },
        headers: {
          Authorization: JsonWebToken.encode(user_id: admin_user.id)
        }, as: :json
      end.to_not change { Book.count }
      expect(response).to have_http_status :unprocessable_entity
    end
  end

  context 'when normal user' do
    it 'does not create book if not admin' do
      expect do
        post api_v1_books_url, params: {
          book: @book_attributes
        },
        headers: {
          Authorization: JsonWebToken.encode(user_id: user.id)
        }, as: :json
      end.to_not change { Book.count }
      expect(response).to have_http_status :forbidden
    end
  end

  context 'not logged in' do
    it 'does nto create book if not logged in' do
      expect do
        post api_v1_books_url, params: {
          book: @book_attributes
        }, as: :json
      end.to_not change { Book.count }
      expect(response).to have_http_status :forbidden
    end
  end
end

RSpec.describe "PATCH api/v1/book/:id", type: :request do
  let(:admin_user) { FactoryBot.create(:user, :admin) }
  let(:user) { FactoryBot.create(:user) }
  let!(:test_book) { FactoryBot.create(:book) }
  context 'when admin' do
    it 'updates book with valid attributes' do
      patch api_v1_book_url(test_book), params: {
        book: { title: 'Updated Title' }
      },
      headers: {
        Authorization: JsonWebToken.encode(user_id: admin_user.id)
      }, as: :json
      json_response = JSON.parse(response.body)
      expect(json_response['title']).to eq 'Updated Title'
      expect(response).to have_http_status :success
    end
    it 'does not update book with invalid attributes' do
      patch api_v1_book_url(test_book), params: {
        book: { title: '' }
      },
      headers: {
        Authorization: JsonWebToken.encode(user_id: admin_user.id)
      }, as: :json
      expect(response).to have_http_status :unprocessable_entity
    end
  end

  context 'when normal user' do
    it 'does not update book' do
      patch api_v1_book_url(test_book), params: {
        book: { title: 'Updated Title' }
      },
      headers: {
        Authorization: JsonWebToken.encode(user_id: user.id)
      }, as: :json
      expect(response).to have_http_status :forbidden
    end
  end

  context 'when not logged in' do
    it 'does not update book' do
      patch api_v1_book_url(test_book), params: {
        book: { title: 'Updated Title' }
      }, as: :json
      expect(response).to have_http_status :forbidden
    end
  end
end
