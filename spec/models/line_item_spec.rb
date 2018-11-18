require 'rails_helper'

RSpec.describe LineItem, type: :model do
  it { is_expected.to respond_to(:order) }
  it { is_expected.to respond_to(:quantity) }
  it { is_expected.to respond_to(:unit_price) }
  it { is_expected.to respond_to(:widget) }

  it { is_expected.to validate_presence_of(:order) }
  it { is_expected.to validate_presence_of(:quantity) }
  it { is_expected.to validate_presence_of(:unit_price) }
  it { is_expected.to validate_presence_of(:widget) }

  describe 'associations' do
    it { should belong_to(:order) }
    it { should belong_to(:widget) }
  end

  describe 'validations' do
    context 'when quantity is less than or equal to 0' do
      it 'is invalid' do
        li = build(:line_item, quantity: -1)
        expect(li).to be_invalid
      end
    end

    context 'when unit_price is less than or equal to 0' do
      it 'is invalid' do
        li = build(:line_item, unit_price: -3)
        expect(li).to be_invalid
      end
    end

    context 'when unit_price and quantity are both greater than 0' do
      it 'is valid' do
        li = build(:line_item, quantity: 2, unit_price: 3)
        expect(li).to be_valid
      end
    end
  end
end
