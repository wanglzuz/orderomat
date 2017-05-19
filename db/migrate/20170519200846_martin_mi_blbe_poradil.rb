class MartinMiBlbePoradil < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders, :state, :status
  end
end
