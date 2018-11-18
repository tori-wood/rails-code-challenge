FactoryBot.define do
  factory :line_item do
    order
    widget
    quantity { 4 }
    unit_price { 5 }
  end
end
