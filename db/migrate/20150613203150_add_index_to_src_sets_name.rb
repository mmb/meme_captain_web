class AddIndexToSrcSetsName < ActiveRecord::Migration
  def change
    add_index :src_sets, :name
  end
end
