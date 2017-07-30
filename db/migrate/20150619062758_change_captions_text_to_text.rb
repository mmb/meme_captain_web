class ChangeCaptionsTextToText < ActiveRecord::Migration[5.0]
  def change
    change_column :captions, :text, :text
  end
end
