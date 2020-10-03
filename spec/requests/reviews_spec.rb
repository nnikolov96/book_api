require 'rails_helper'

RSpec.describe "POST api/v1/books/:id/reviews", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:book) { FactoryBot.create(:book) }
  before do
    @review_attributes = FactoryBot.attributes_for(:review, user: user, book: book)
  end

  context 'when logged in' do
    it 'creates review with valid attributes' do
      expect do
        post api_v1_book_reviews_url(book), params: {
          review: @review_attributes
        },
        headers: {
          Authorization: JsonWebToken.encode(user_id: user.id)
        }, as: :json
      end.to change { book.reviews.count }.by(1)
      expect(response).to have_http_status :created
    end

    it 'does not create review with invalid attributes' do
      expect do
        post api_v1_book_reviews_url(book), params: {
          review: { rating: '', text: '' }
        },
        headers: {
          Authorization: JsonWebToken.encode(user_id: user.id)
        }, as: :json
      end.to_not change { book.reviews.count }
      expect(response).to have_http_status :unprocessable_entity
    end
  end

  context 'not logged in' do
    it 'does not create book if not logged in' do
      expect do
        post api_v1_book_reviews_url(book), params: {
          book: @review_attributes
        }, as: :json
      end.to_not change { Book.count }
      expect(response).to have_http_status :forbidden
    end
  end
end
