class BookSerializer
  include FastJsonapi::ObjectSerializer

  attributes :title, :isbn, :description, :average_rating

  attribute :image do |object|
    Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true) if object.image.attached?
  end
  attribute :last_reviews do |object|
    object.reviews.select(:text, :id).order(created_at: :desc).take(3)
  end

  link :self, :url
end
