class AddWorkInProgressToGendImage < ActiveRecord::Migration[5.0]
  def change
    add_column :gend_images, :work_in_progress, :boolean, :default => true
  end
end
