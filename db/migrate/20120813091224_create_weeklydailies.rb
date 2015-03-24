class CreateWeeklydailies < ActiveRecord::Migration
  def self.up
    create_table :weeklydailies do |t|
      t.column :user_id, :integer
      t.column :wd_work, :text
      t.column :wd_probles, :text
      t.column :wd_plan, :text
      t.column :wd_proposal, :text
      t.timestamps
    end
     add_index :weeklydailies,:user_id
  end

  def self.down
     remove_index :weeklydailies,:user_id
    drop_table :weeklydailies
  end
end
