require 'rails_helper'

RSpec.describe Widget, type: :model do
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:msrp) }
end
