class AddFreetimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :freetime, :text
  end
end
