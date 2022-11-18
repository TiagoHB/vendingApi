class AddChangesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :coin5, :integer, default: 0
    add_column :users, :coin10, :integer, default: 0
    add_column :users, :coin20, :integer, default: 0
    add_column :users, :coin50, :integer, default: 0
    add_column :users, :coin100, :integer, default: 0
  end
end
