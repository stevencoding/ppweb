class AddEventGuestIdToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :event_guest_id, :integer
  end
end
