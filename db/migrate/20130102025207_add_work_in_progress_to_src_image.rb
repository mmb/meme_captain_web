class AddWorkInProgressToSrcImage < ActiveRecord::Migration[4.2]
  def change
    add_column :src_images, :work_in_progress, :boolean, :default => true
  end
end
