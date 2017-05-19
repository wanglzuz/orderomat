class RenameAccessToken < ActiveRecord::Migration[5.1]
  def change

    rename_column :companies, :accessToken, :access_token
    remove_column :companies, :string

  end
end
