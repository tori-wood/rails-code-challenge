FactoryBot.define do
  factory :order do
    shipped_at { Time.now }
  end

  trait :unshipped do
    shipped_at { nil }
  end
end
