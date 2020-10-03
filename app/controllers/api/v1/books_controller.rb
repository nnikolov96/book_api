class Api::V1::BooksController < ApplicationController
  before_action :check_admin, only: %i[create update]
  before_action :set_book, only: %i[update]

  def create
    @book = Book.new(book_params)
    if @book.save
      render json: @product, status: :created
    else
      render json: { errors: @book.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  private

  def book_params
    params.require(:book).permit(:isbn, :title, :description)
  end

  def set_book
    @book = Book.find(params[:id])
  end
end
