class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :customer
      t.references :provider
      t.text :description
      t.timestamp :created
      t.timestamp :deadline
      t.integer :state

      t.timestamps
    end
  end
end
