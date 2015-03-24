class CreateMbosUsers < ActiveRecord::Migration
  def self.up
    create_table :mbos_users,:id => false do |t|
      t.column :mbo_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
    end
    add_index :mbos_users, [:mbo_id, :user_id], :unique => true, :name => :mbos_users_ids
  end

  def self.down
    remove_index :mbos_users
    drop_table :mbos_users
  end
end
