FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@gmail.com" }
    password { 'Test1234#' }
    password_confirmation { 'Test1234#' }
    admin { false }

    trait :admin do
      admin { true }
    end
  end
end
