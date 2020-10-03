FactoryBot.define do
  factory :book do
    title { 'The Fountainhead' }
    description { 'Some Random Description' }
    sequence(:isbn) { |n| "unique_isbn_#{n}" }
  end
end
