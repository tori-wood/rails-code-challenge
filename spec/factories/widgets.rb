FactoryBot.define do
  factory :widget do
    name { Faker::Commerce.product_name }
  end
end
