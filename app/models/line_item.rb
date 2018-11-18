class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :widget

  validates :order, :quantity, :unit_price, :widget, presence: true
  validates :quantity, :unit_price, numericality: { greater_than: 0 }
end
