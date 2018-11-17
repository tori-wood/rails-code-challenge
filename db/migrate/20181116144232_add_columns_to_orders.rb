class AddColumnsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :expedite, :boolean, default: false
    add_column :orders, :returns, :boolean, default: false
    add_column :orders, :warehouse, :boolean, default: false
  end
end
