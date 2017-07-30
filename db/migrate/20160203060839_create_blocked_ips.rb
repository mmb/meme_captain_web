class CreateBlockedIps < ActiveRecord::Migration[4.2]
  def change
    create_table :blocked_ips do |t|
      t.text :ip, null: false
      t.timestamps null: false
    end
  end
end
