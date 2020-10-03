class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :text, presence: true, length: { minimum: 20, maximum: 250 }
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5.0 }
end
