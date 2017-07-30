class AddWorkInProgressToSrcImage < ActiveRecord::Migration[5.0]
  def change
    add_column :src_images, :work_in_progress, :boolean, :default => true
  end
end
