class CreateProjdailyheads < ActiveRecord::Migration
  def self.up
    create_table :projdailyheads do |t|
      t.column :user_id, :integer
      t.column :user_name, :string
      t.column :pd_date, :date
      t.column :pd_name, :string
      t.column :pd_isdelay, :string
      t.column :pd_help, :text
      t.column :pd_risk, :text
    end

    add_index :projdailyheads,:user_id
  end

  def self.down
    remove_index :projdailyheads,:user_id
    drop_table :projdailyheads
  end
end
