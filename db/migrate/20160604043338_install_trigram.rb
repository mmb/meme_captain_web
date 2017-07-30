class InstallTrigram < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'pg_trgm'
  end
end
