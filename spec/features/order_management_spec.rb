require 'rails_helper'
require 'spec_helper'

RSpec.feature 'Order management', :type => :feature do
  it 'User visits the Orders index page' do
    order_id = create(:order).id
    visit orders_path

    click_link order_id

    expect(current_path).to eq order_path(order_id)
    expect(page).to have_text("Order #{order_id}")
  end

  it 'User creates a new order with all fields; order and line items created' do
    widget = create(:widget)
    order_count = Order.count
    line_item_count = LineItem.count

    visit new_order_path
    check 'Expedited shipping?'
    select(widget.name, from: 'Widget', visible: false)
    fill_in('Quantity', with: 3)
    fill_in('Unit Price', with: 4)

    click_button 'Submit'

    expect(page).to have_text("Your order has been submitted.")
    expect(Order.count).to eq order_count + 1
    expect(LineItem.count).to eq line_item_count + 1
  end

  it 'User attempts to create a new order with missing widget' do
    visit new_order_path
    fill_in('Quantity', with: 3)
    fill_in('Unit Price', with: 4)

    click_button 'Submit'

    expect(page).to have_text("Line items widget must exist")
  end

  it 'User attempts to create a new order with quantity less than 0' do
    widget = create(:widget)
    visit new_order_path
    select(widget.name, from: 'Widget', visible: false)
    fill_in('Quantity', with: -1)
    fill_in('Unit Price', with: 4)
    click_button 'Submit'

    expect(page).to have_text("Line items quantity must be greater than 0")
  end

  it 'User creates a new order with unit price less than 0' do
    widget = create(:widget)
    visit new_order_path
    select(widget.name, from: 'Widget', visible: false)
    fill_in('Quantity', with: 3)
    fill_in('Unit Price', with: -4)
    click_button 'Submit'

    expect(page).to have_text("Line items unit price must be greater than 0")
  end
end
