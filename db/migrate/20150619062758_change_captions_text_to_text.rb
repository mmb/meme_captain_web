class ChangeCaptionsTextToText < ActiveRecord::Migration[4.2]
  def change
    change_column :captions, :text, :text
  end
end
