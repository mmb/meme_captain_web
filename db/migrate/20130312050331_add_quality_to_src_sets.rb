class AddQualityToSrcSets < ActiveRecord::Migration[4.2]

  def change
    add_column :src_sets, :quality, :integer, :default => 0, :null => false
    add_index :src_sets, :quality
  end

end
