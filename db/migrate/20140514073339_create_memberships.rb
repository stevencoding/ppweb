class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :event_id
      t.integer :event_member_id

      t.timestamps
    end
  end
end
