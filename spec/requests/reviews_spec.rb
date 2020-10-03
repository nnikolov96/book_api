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


RSpec.describe "PATCH api/v1/books/:id/review/:id", type: :request do
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }
  let(:book) { FactoryBot.create(:book) }
  let!(:review) { FactoryBot.create(:review, user: user, book: book) }

  context 'when admin' do
    it 'updates review with valid attributes' do
      patch api_v1_book_review_url(book, review), params: {
        review: { text: 'I changed my mind about this specific book', rating: '2.3' }
      },
      headers: {
        Authorization: JsonWebToken.encode(user_id: admin.id)
      }, as: :json
      json_response = JSON.parse(response.body)
      expect(json_response['text']).to eq 'I changed my mind about this specific book'
      expect(json_response['rating']).to eq '2.3'
      expect(response).to have_http_status :created
    end

    it 'does not update review with invalid attributes' do
      patch api_v1_book_review_url(book, review), params: {
        review: { text: '' }
      },
      headers: {
        Authorization: JsonWebToken.encode(user_id: admin.id)
      }, as: :json

      expect(response).to have_http_status :unprocessable_entity
    end
  end

  context 'when logged in and owners review' do
    it 'updates review with valid attributes' do
      patch api_v1_book_review_url(book, review), params: {
        review: { text: 'I have something new to write here', rating: '4.4' }
      },
      headers: {
        Authorization: JsonWebToken.encode(user_id: user.id)
      }, as: :json
      json_response = JSON.parse(response.body)
      expect(json_response['text']).to eq 'I have something new to write here'
      expect(json_response['rating']).to eq '4.4'
      expect(response).to have_http_status :created
    end

    it 'does not update review with invalid attributes' do
      patch api_v1_book_review_url(book, review), params: {
        review: { text: 'too short', rating: '10' }
      },
      headers: {
        Authorization: JsonWebToken.encode(user_id: user.id)
      }, as: :json
      expect(response).to have_http_status :unprocessable_entity
    end
  end

  context 'when logged in but not owners review' do
    it 'does not update review it doesnt own' do
      patch api_v1_book_review_url(book, review), params: {
        review: { text: 'I have something new to write here', rating: '4.4' }
      },
      headers: {
        Authorization: JsonWebToken.encode(user_id: another_user.id)
      }, as: :json
      expect(response).to have_http_status :forbidden
    end
  end

  context 'when not logged in' do
    it 'does not update reviews when not logged in' do
      patch api_v1_book_review_url(book, review), params: {
        review: { text: 'Review for anonnymous user, shouldnt work', rating: '2' }
      }, as: :json
      expect(response).to have_http_status :forbidden
    end
  end
end

RSpec.describe "DELETE api/v1/books/:id/review/:id", type: :request do
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }
  let(:book) { FactoryBot.create(:book) }
  let!(:review) { FactoryBot.create(:review, user: user, book: book) }

  context 'when admin' do
    it 'deletes review when admin' do
      expect do
        delete api_v1_book_review_url(book, review),
        headers: { Authorization: JsonWebToken.encode(user_id: admin.id)}, as: :json
      end.to change { book.reviews.count }.by(-1)
      expect(response).to have_http_status :no_content
    end
  end

  context 'when logged in and owners review' do
    it 'deletes review when reviews owner' do
      expect do
        delete api_v1_book_review_url(book, review),
        headers: { Authorization: JsonWebToken.encode(user_id: user.id)}, as: :json
      end.to change { book.reviews.count }.by(-1)
      expect(response).to have_http_status :no_content
    end
  end

  context 'when logged in but does not own review' do
    it 'does not delete review when not owner' do
      expect do
        delete api_v1_book_review_url(book, review),
        headers: { Authorization: JsonWebToken.encode(user_id: another_user.id)}, as: :json
      end.to_not(change { book.reviews.count })
      expect(response).to have_http_status :forbidden
    end
  end

  context 'when not logged' do
    it 'does not delete review when not logged in' do
      expect do
        delete api_v1_book_review_url(book, review), as: :json
      end.to_not(change { book.reviews.count })
      expect(response).to have_http_status :forbidden
    end
  end
end

RSpec.describe "GET api/v1/books/:id/reviews", type: :request do
  let(:book) { FactoryBot.create(:book) }
  let(:user) { FactoryBot.create(:user) }
  before do
    25.times do
      FactoryBot.create(:review, book: book, user: user)
    end
  end

  it 'lists all reviews for book' do
    byebug
    get api_v1_book_reviews_url(book), as: :json
    expect(response).to have_http_status(:success)
  end
end