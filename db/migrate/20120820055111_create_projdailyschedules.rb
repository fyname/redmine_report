class CreateProjdailyschedules < ActiveRecord::Migration
  def self.up
    create_table :projdailyschedules do |t|
      t.column :projdailyhead_id, :integer
      t.column :pd_version, :string
      t.column :pd_bugs, :text
    end
    add_index :projdailyschedules,:projdailyhead_id
  end

  def self.down
    remove_index :projdailyschedules,:projdailyhead_id
    drop_table :projdailyschedules
  end
end
