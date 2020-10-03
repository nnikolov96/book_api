class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy
  validates :title, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :isbn, presence: true, uniqueness: true

  def rating
    if reviews.present?
      reviews.average(:rating).round(1)
    else
      0.0
    end
  end
end
