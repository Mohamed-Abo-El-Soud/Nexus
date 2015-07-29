class AddSenderAndRecieverToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :sender_id, :integer
    add_column :messages, :reciever_id, :integer
    add_index :messages, :reciever_id
    add_index :messages, :sender_id
    add_index :messages, [:reciever_id, :sender_id, :created_at], unique: true
  end
end
