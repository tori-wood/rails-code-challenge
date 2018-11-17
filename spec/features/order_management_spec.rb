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

  it 'User creates a new order' do 
    visit new_order_path
    check 'expedite'

    click_button 'Submit'

    expect(page).to have_text("Your order has been submitted.")
  end
end
