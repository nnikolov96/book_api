require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { FactoryBot.create(:book) }

  context 'validations' do
    it 'has a valid factory' do
      expect(book).to be_valid
    end

    context 'title' do
      it 'is not valid without title' do
        book.title = nil
        expect(book).to_not be_valid
        expect(book.errors[:title]).to include "can't be blank"
      end

      it 'is not valid with title shorter than 2 characters' do
        book.title = 't'
        expect(book).to_not be_valid
        expect(book.errors[:title]).to include 'is too short (minimum is 2 characters)'
      end

      it 'is not valid with title longer than 100 characters' do
        book.title = 't' * 101
        expect(book).to_not be_valid
        expect(book.errors[:title]).to include 'is too long (maximum is 100 characters)'
      end
    end

    context 'isbn' do
      it 'is not valid without isbn' do
        book.isbn = nil
        expect(book).to_not be_valid
        expect(book.errors[:isbn]).to include "can't be blank"
      end
      it 'has unique isbn' do
        book_dup = book.dup
        expect(book_dup).to_not be_valid
        expect(book_dup.errors[:isbn]).to include 'has already been taken'
      end
    end

    it 'is not valid with description longer than 1000 characters' do
      book.description = 't' * 1001
      expect(book).to_not be_valid
      expect(book.errors[:description]).to include 'is too long (maximum is 1000 characters)'
    end
  end

  context 'rating' do
    let(:book) { FactoryBot.create(:book) }
    it 'has 0.0 rating when no reviews' do
      expect(book.average_rating).to eq 0.0
    end

    it 'calculates its average score when reviews present' do
      FactoryBot.create(:review, rating: 5, book: book)
      FactoryBot.create(:review, rating: 3, book: book)
      expect(book.average_rating).to eq(4)
    end
  end

  context 'search' do
    let!(:book_one) { FactoryBot.create(:book, title: 'First Book') }
    let!(:book_two) { FactoryBot.create(:book, title: 'Second Book') }
    let!(:book_three) { FactoryBot.create(:book, title: 'First but different') }
    it 'filters book by provided search term' do
      books = Book.filter_by_title('first')
      expect(books).to include book_one
      expect(books).to include book_three
      expect(books).to_not include book_two
    end
  end
end
