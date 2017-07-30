class AddApiTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :api_token, :text
    add_index :users, :api_token, length: 32
  end
end
