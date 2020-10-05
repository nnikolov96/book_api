class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_one_attached :image
  validates :title, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :isbn, presence: true, uniqueness: true

  scope :filter_by_title, ->(term) { where('lower(title) LIKE ?', "%#{term.downcase}%") }

  def self.search(params = {})
    books = Book.all
    books = books.filter_by_title(params[:term]) if params[:term]
    books
  end

  def update_average_rating
    return 0.0 unless reviews.present?

    avg = reviews.average(:rating).round(1)
    update_column(:average_rating, avg)
  end

  def url
    Rails.application.routes.url_helpers.api_v1_book_path(self)
  end
end
