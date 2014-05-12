class AddUidAndPriceToEvents < ActiveRecord::Migration
  def change
    add_column :events, :uid, :string
    add_column :events, :price, :string, default: ''
  end
end
