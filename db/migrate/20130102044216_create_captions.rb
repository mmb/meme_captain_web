class CreateCaptions < ActiveRecord::Migration[4.2]
  def change
    create_table :captions do |t|
      t.string :text
      t.string :font
      t.float :top_left_x_pct
      t.float :top_left_y_pct
      t.float :width_pct
      t.float :height_pct
      t.references :gend_image

      t.timestamps
    end
    add_index :captions, :gend_image_id
  end
end
