class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :ico
      t.string :accessToken
      t.string :string

      t.timestamps
    end
  end
end
