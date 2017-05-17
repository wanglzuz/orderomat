class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.Company :customer
      t.Company :provider
      t.text :description
      t.timestamp :created
      t.timestamp :deadline
      t.integer :state

      t.timestamps
    end
  end
end
