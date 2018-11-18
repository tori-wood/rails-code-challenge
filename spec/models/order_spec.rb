require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should have_many(:line_items) }
    it { should accept_nested_attributes_for(:line_items) }

    context 'when line_items present' do
      it 'is valid' do
        order = build(:order)
        line_item = create(:line_item)
        order.line_items = [line_item]
        expect(order).to be_valid
      end
    end

    context 'when line_items are not present' do
      it 'is invalid' do
        order = build(:order)
        order.line_items = []
        expect(order).to be_invalid
      end
    end
  end

  describe '#shipped?' do
    it { is_expected.to respond_to(:shipped?) }

    context 'when a shipped date exists' do
      before { subject.update(shipped_at: Time.now) }
      it { is_expected.to be_shipped }
    end

    context 'when no shipped date is present' do
      it { is_expected.to_not be_shipped }
    end
  end

  describe '#expedited?' do
    it { is_expected.to respond_to(:expedited?) }

    context 'when expedite is true' do
      before { subject.update(expedite: true) }
      it { is_expected.to be_expedited }
    end

    context 'when expedite is false' do
      it { is_expected.to_not be_expedited }
    end
  end

  describe '#returnable?' do
    it { is_expected.to respond_to(:returnable?) }

    context 'when returns is true' do
      before { subject.update(returns: true) }
      it { is_expected.to be_returnable }
    end

    context 'when returns is false' do
      it { is_expected.to_not be_returnable }
    end
  end

  describe '#warehoused?' do
    it { is_expected.to respond_to(:warehoused?) }

    context 'when warehouse is true' do
      before { subject.update(warehouse: true) }
      it { is_expected.to be_warehoused }
    end

    context 'when warehouse is false' do
      it { is_expected.to_not be_warehoused }
    end
  end

  describe '#item_count' do
    it { is_expected.to respond_to(:item_count) }

    context 'when line_items are present' do
      before { subject.update(line_items: [create(:line_item)]) }
      it { expect(subject.item_count).to eq 1 }
    end

    context 'when line_items are not present' do
      before { subject.update(line_items: []) }
      it { expect(subject.item_count).to eq 0 }
    end
  end

  describe '#order_total' do
    it { is_expected.to respond_to(:order_total) }

    context 'when line_items are present' do
      before { subject.update(line_items: [create(:line_item, quantity: 2, unit_price: 3)]) }
      it { expect(subject.order_total).to eq 6 }
    end

    context 'when line_items are not present' do
      before { subject.update(line_items: []) }
      it { expect(subject.order_total).to eq 0 }
    end
  end

  describe 'shipped_at scopes' do
    let!(:shipped_orders) { create_list(:order, 3) }
    let!(:unshipped_orders) { create_list(:order, 3, :unshipped) }
    
    context ':shipped' do 
      it 'filters out unshipped orders' do
        expect(Order.shipped.size).to eq 3
        expect(Order.shipped.all? { |order| order.shipped? }).to eq true
      end
    end

    context ':unshipped' do 
      it 'filters out shipped orders' do
        expect(Order.unshipped.size).to eq 3
        expect(Order.unshipped.all? { |order| !order.shipped? }).to eq true
      end
    end
  end

  describe 'latest scope' do
    let(:shipped_orders) { [] }
    let(:sorted_shipped) { [] }
    let(:sorted_all) { [] }
    let(:unshipped_orders) { create_list(:order, 3, :unshipped) }

    before do
      3.times do
        shipped_at = Time.now - Faker::Number.between(1, 300).hours
        shipped_orders << create(:order, shipped_at: shipped_at, created_at: shipped_at - 2.hours)
      end

      sorted_shipped << shipped_orders.sort! { |order_a, order_b| order_b.shipped_at <=> order_a.shipped_at }
      sorted_all << sorted_shipped
      sorted_all << unshipped_orders
    end

    context ':latest' do
      context 'when only scope' do
        it 'orders by shipped_at column by default' do
          expect(Order.latest).to match_array(sorted_all.flatten)
        end

        it 'orders by column passed in' do
          sorted_by_created_at = Order.all.order(created_at: :desc)
          expect(Order.latest(:created_at)).to match_array(sorted_by_created_at)
        end
      end

      context 'when also shipped scope' do
        it 'filters out unshipped_orders and sorts by shipped_at date' do
          expect(Order.shipped.latest).to match_array(sorted_shipped.flatten)
        end
      end

      context 'when also unshipped scope' do
        it 'filters out shipped_orders and does not raise an error' do
          expect(Order.unshipped.latest).to match_array(unshipped_orders)
        end
      end
    end
  end
end
