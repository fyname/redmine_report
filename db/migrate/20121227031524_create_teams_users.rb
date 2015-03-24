class CreateTeamsUsers < ActiveRecord::Migration
  def self.up
    create_table :teams_users,:id => false do |t|
      t.column :team_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
    end
    add_index :teams_users, [:team_id, :user_id], :unique => true, :name => :teams_users_ids
  end

  def self.down
    remove_index :teams_users
    drop_table :teams_users
  end
end