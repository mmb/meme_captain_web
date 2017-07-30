class AddIndexToSrcSetsName < ActiveRecord::Migration[5.0]
  def change
    add_index :src_sets, :name
  end
end
