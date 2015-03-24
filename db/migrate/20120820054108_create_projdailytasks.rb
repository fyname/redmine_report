class CreateProjdailytasks < ActiveRecord::Migration
  def self.up
    create_table :projdailytasks do |t|
      t.column :projdailyhead_id, :integer
      t.column :pd_module, :string
      t.column :pd_isnew, :string
      t.column :pd_start, :date
      t.column :pd_commitment, :date
      t.column :pd_actual, :date
      t.column :pd_delaytime, :integer
      t.column :pd_phase, :text
      t.column :pd_username, :string
      t.column :pd_version, :string
      t.column :pd_proportion, :string
    end
     add_index :projdailytasks,:projdailyhead_id
  end

  def self.down
    remove_index :projdailytasks,:projdailyhead_id
    drop_table :projdailytasks
  end
end
