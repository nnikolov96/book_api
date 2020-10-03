FactoryBot.define do
  factory :review do
    rating { '5.0' }
    text { 'Random text with minimum 20 characters' }
    user
    book
  end
end
