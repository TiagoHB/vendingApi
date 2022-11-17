class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :productName
      t.integer :amountAvailable, null: false, default: 0
      t.integer :cost, null: false, default: 0
      t.references :seller, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
