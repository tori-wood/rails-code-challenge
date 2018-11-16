class Order < ApplicationRecord
  def expedited?
    @expedite
  end

  def returnable?
    @returns
  end

  def settings(opts = {})
    @expedite = opts[:expedite].presence
    @returns = opts[:returns].presence
    @warehouse = opts[:warehouse].presence
  end

  def shipped?
    shipped_at.present?
  end

  def warehoused?
    @warehouse
  end

  scope :shipped, -> { where('shipped_at is not null') }
  scope :unshipped, -> { where('shipped_at is null') }
  scope :latest, -> (column = :shipped_at) { order(column => :desc) }
end
