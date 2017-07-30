class AddPasswordResetTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :password_reset_token, :text
    add_index :users, :password_reset_token, length: 32

    add_column :users, :password_reset_expires_at, :datetime
  end
end
