FactoryBot.define do
  factory :order do
    shipped_at { Time.now }

    after(:build) do |order|
      order.line_items = create_list(:line_item, 1, order: order)
    end
  end

  trait :unshipped do
    shipped_at { nil }

    after(:build) do |order|
      order.line_items = create_list(:line_item, 1, order: order)
    end
  end
end
