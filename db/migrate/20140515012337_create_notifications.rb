class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :action
      t.integer :sender_id
      t.integer :receiver_id
      t.boolean :unread, default: true
      t.belongs_to :notifiable, polymorphic: true

      t.timestamps
    end
    add_index :notifications, [:notifiable_id, :notifiable_type]
    add_index :notifications, [:receiver_id]
  end
end
