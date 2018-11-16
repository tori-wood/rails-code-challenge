require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe '#index' do
    subject { get :index }
    it { is_expected.to have_http_status(:ok) }
  end

  describe '#show' do
    let(:order) { create(:order) }
    subject { get :show, params: { id: order.id } }
    it { is_expected.to have_http_status(:ok) }
  end
end
