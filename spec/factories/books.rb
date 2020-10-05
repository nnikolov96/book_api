FactoryBot.define do
  factory :book do
    title { 'The Fountainhead' }
    description { 'Some Random Description' }
    sequence(:isbn) { |n| "unique_isbn_#{n}" }

    trait :with_image do
      image { Rack::Test::UploadedFile.new('spec/support/assets/test_image.png', 'image/png') }
    end
  end
end
