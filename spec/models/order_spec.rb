require 'rails_helper'

RSpec.describe Order, type: :model do
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

  describe '#settings' do
    it { is_expected.to respond_to(:settings) }

    context 'when expedite is present' do
      before { subject.settings(expedite: true) }
      it { is_expected.to be_expedited }
    end

    context 'when returns is present' do
      before { subject.settings(returns: true) }
      it { is_expected.to be_returnable }
    end

    context 'when warehouse is present' do
      before { subject.settings(warehouse: true) }
      it { is_expected.to be_warehoused }
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
    let(:sorted_orders) { Order.order(:shipped_at) }

    before do
      3.times { shipped_orders << create(:order, shipped_at: Time.now - Random.rand(300).hours) }
      sorted_shipped << shipped_orders.sort_by { |order| order.shipped_at }
      sorted_all << (shipped_orders << unshipped_orders)
    end

    context ':latest' do
      context 'when only scope' do
        it 'orders by shipped_at column by default' do
          expect(Order.latest).to match_array(sorted_all.flatten)
        end

        it 'orders by column passed in' do
          sorted_by_created_at = Order.all.sort_by { |order| order.created_at }
          expect(Order.latest(:created_at)).to match_array(sorted_by_created_at.flatten)
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
