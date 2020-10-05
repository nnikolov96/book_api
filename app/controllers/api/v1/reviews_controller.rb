class Api::V1::ReviewsController < ApplicationController
  before_action :set_book
  before_action :set_review, only: %i[update destroy]
  before_action :check_login, only: %i[create update destroy]
  before_action :check_owner!, only: %i[update destroy]

  def index
    @pagy, @reviews = pagy(@book.reviews.all, items: 20)
    options = {
      links: {
        book: api_v1_book_path(@book),
        first: api_v1_book_reviews_path(page: 1),
        last: api_v1_book_reviews_path(page: @pagy.last),
        prev: api_v1_book_reviews_path(page: @pagy.prev),
        next: api_v1_book_reviews_path(page: @pagy.next)
      }
    }
    render json: ReviewSerializer.new(@reviews, options).serializable_hash
  end

  def create
    @review = @book.reviews.new(review_params)
    if @review.save
      render json: @review, status: :created
    else
      render json: { errors: @review.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @review.update(review_params)
      render json: @review, status: :created
    else
      render json: { errors: @review.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    head 204
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_review
    @review = @book.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:text, :rating).merge(user: current_user)
  end

  def check_owner!
    head :forbidden unless @current_user.admin? || @review.user == @current_user
  end
end
