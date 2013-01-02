class AddWorkInProgressToSrcImage < ActiveRecord::Migration
  def change
    add_column :src_images, :work_in_progress, :boolean, :default => true
  end
end
