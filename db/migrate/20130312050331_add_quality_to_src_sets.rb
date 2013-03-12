class AddQualityToSrcSets < ActiveRecord::Migration

  def change
    add_column :src_sets, :quality, :integer, :default => 0, :null => false
    add_index :src_sets, :quality
  end

end
