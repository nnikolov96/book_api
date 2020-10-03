class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  validates :email, presence: true, length: { minimum: 5, maximum: 120 }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6, maximum: 26 }
  has_secure_password
end
