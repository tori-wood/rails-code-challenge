class Order < ApplicationRecord

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

  scope :shipped, -> { where('shipped_at is not null') }
  scope :unshipped, -> { where('shipped_at is null') }
  scope :latest, -> (column = :shipped_at) { order(column => :desc) }
end
