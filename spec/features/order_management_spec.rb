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

  it 'User creates a new order with all fields' do 
    widget = create(:widget)
    visit new_order_path
    check 'Would you like this order to have expedited shipping?'
    select(widget.name, from: 'Widget', visible: false)
    fill_in('Quantity', with: 3)
    fill_in('Unit Price', with: 4)

    click_button 'Submit'

    expect(page).to have_text("Your order has been submitted.")
  end

  it 'User creates a new order with missing fields' do
    widget = create(:widget)
    visit new_order_path
    select(widget.name, from: 'Widget', visible: false)

    click_button 'Submit'

    expect(page).to have_text("There seems to be an issue with your order.")
  end
end
