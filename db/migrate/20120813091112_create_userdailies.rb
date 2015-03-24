class CreateUserdailies < ActiveRecord::Migration
  def self.up
    create_table :userdailies do |t|
      t.column :user_id, :integer
      t.column :ud_work, :text
      t.column :ud_probles, :text
      t.column :ud_plan, :text
      t.column :ud_proposal, :text
      t.timestamps
    end
    add_index :userdailies,:user_id
  end

  def self.down
    remove_index :userdailies,:user_id
    drop_table :userdailies
  end
end
