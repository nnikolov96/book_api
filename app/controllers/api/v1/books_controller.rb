class Api::V1::BooksController < ApplicationController
  before_action :check_admin, only: %i[create update destroy]
  before_action :set_book, only: %i[update destroy show]

  def index
    @books = Book.all
    render json: BookSerializer.new(@books).serializable_hash
  end

  def show
    render json: BookSerializer.new(@book).serializable_hash
  end

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

  def destroy
    @book.destroy
    head 204
  end

  private

  def book_params
    params.require(:book).permit(:isbn, :title, :description)
  end

  def set_book
    @book = Book.find(params[:id])
  end
end
