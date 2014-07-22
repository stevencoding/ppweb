class AddEmailInviteToEvents < ActiveRecord::Migration
  def change
    add_column :events, :email_invite, :text
  end
end
