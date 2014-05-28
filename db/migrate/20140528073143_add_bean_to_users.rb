class AddBeanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bean, :integer
  end
end
