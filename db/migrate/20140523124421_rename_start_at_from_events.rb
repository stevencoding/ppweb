class RenameStartAtFromEvents < ActiveRecord::Migration
  def change
    rename_column :events, :start_at, :start
  end
end
