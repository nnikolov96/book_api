class ReviewSerializer
  include FastJsonapi::ObjectSerializer
  attributes :text, :rating
  belongs_to :book
end
