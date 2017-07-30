class CreateBlockedIps < ActiveRecord::Migration[5.0]
  def change
    create_table :blocked_ips do |t|
      t.text :ip, null: false
      t.timestamps null: false
    end
  end
end
