class Api::V1::ReviewsController < ApplicationController
  before_action :set_book
  before_action :check_login, only: %i[create]

  def create
    @review = @book.reviews.new(review_params)
    if @review.save
      render json: @review, status: :created
    else
      render json: { errors: @review.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def review_params
    params.require(:review).permit(:text, :rating).merge(user: current_user)
  end
end
