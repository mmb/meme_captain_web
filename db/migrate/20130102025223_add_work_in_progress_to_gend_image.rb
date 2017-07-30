class AddWorkInProgressToGendImage < ActiveRecord::Migration[4.2]
  def change
    add_column :gend_images, :work_in_progress, :boolean, :default => true
  end
end
