class Order < ApplicationRecord

  has_many :line_items

  accepts_nested_attributes_for :line_items, :reject_if => lambda { |l| l[:widget_id].blank? }, :allow_destroy => true

  def shipped?
    shipped_at.present?
  end

  def expedited?
    expedite
  end

  def returnable?
    returns
  end

  def warehoused?
    warehouse
  end

  def item_count
    line_items.present? ? line_items.size : 0
  end

  def order_total
    line_items.present? ? line_items.inject(0) { |sum, i| sum + i.unit_price * i.quantity } : 0
  end

  scope :shipped, -> { where('shipped_at is not null') }
  scope :unshipped, -> { where('shipped_at is null') }
  scope :latest, -> (column = :shipped_at) { order(column => :desc) }
end
