FactoryBot.define do
  factory :order do
    shipped_at { Time.now }
  end
end
