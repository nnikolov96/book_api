require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:review) { FactoryBot.create(:review) }

  context 'validations' do
    it 'has a valid factory' do
      expect(review).to be_valid
    end

    context 'rating' do
      it 'is not valid without rating' do
        review.rating = nil
        expect(review).to_not be_valid
        expect(review.errors[:rating]).to include "can't be blank"
      end
      it 'is not valid with rating bigger than 5.0' do
        review.rating = 6.2
        expect(review).to_not be_valid
        expect(review.errors[:rating]).to include 'must be less than or equal to 5.0'
      end
      it 'is not valid with rating smaller than 0.0' do
        review.rating = -2
        expect(review).to_not be_valid
        expect(review.errors[:rating]).to include 'must be greater than or equal to 0'
      end
    end

    context 'text' do
      it 'is not valid without text' do
        review.text = nil
        expect(review).to_not be_valid
        expect(review.errors[:text]).to include "can't be blank"
      end
      it 'is not valid with text larger than 250 characters' do
        review.text = 'T' * 251
        expect(review).to_not be_valid
        expect(review.errors[:text]).to include 'is too long (maximum is 250 characters)'
      end
      it 'is not valid with text smaller than 20 characters' do
        review.text = 'short description'
        expect(review).to_not be_valid
        expect(review.errors[:text]).to include 'is too short (minimum is 20 characters)'
      end
    end
  end
end
