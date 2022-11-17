class AddVendingFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :integer, default: 0
    add_column :users, :deposit, :integer, default: 0
  end
end
