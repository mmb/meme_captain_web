class ChangeCaptionsTextToText < ActiveRecord::Migration
  def change
    change_column :captions, :text, :text
  end
end
