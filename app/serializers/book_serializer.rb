class BookSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :isbn, :description
end
