class Book < ApplicationRecord
  has_many :review, dependent: :destroy
  validates :title, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :isbn, presence: true, uniqueness: true
end
