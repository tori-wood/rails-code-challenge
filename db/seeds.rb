# Generate Widgets using first_or_create to ensure no duplicates
10.times do
  name = Faker::Commerce.product_name
  msrp = Faker::Commerce.price(range=1..50, as_string=false)

  Widget.where(name: name).first_or_create!(msrp: msrp)
end

# Generate Orders with random shipped_at dates over the past year, along with some that have not yet shipped
50.times do
  now = Time.now
  shipped_at = [nil, now - Faker::Number.between(1, 24).hours - Faker::Number.between(1, 365).days].sample

  Order.create!(shipped_at: shipped_at)
end

# For each generated Order, create a random amount of LineItems using first_or_create to ensure no duplicates
Order.all.each do |order|
  Faker::Number.between(1, 5).times do
    widget_id = Faker::Number.between(1, Widget.all.size)
    quantity = Faker::Number.between(1, 10)
    unit_price = Faker::Commerce.price(range=1..50, as_string=false)

    LineItem.where(order: order, widget_id: widget_id).first_or_create!(quantity: quantity, unit_price: unit_price)
  end
end
