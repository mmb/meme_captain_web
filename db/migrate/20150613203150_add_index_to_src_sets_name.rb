class AddIndexToSrcSetsName < ActiveRecord::Migration[4.2]
  def change
    add_index :src_sets, :name
  end
end
