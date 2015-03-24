# 创建目标管理

class CreateMbos < ActiveRecord::Migration

   def self.up
    create_table :mbos do |t|
      t.column :team_id, :integer            #部门id
      t.column :ownerid, :integer            #目标所有者id
      t.column :createuserid, :integer       #目标创建者id
      t.column :updateuserid, :integer       #目标修改者id
      t.column :content, :text               #目标内容
      t.column :starttime, :datetime         #目标开始时间
      t.column :endtime, :datetime           #目标结束时间
      t.column :iscomplete, :boolean         #目标是否完成  0否，1 完成
      t.column :remark, :text                #目标备注，未完成原因
      t.timestamps
    end

     add_index :mbos,:team_id
     add_index :mbos,:ownerid
     add_index :mbos,:starttime
     add_index :mbos,:endtime
  end

  def self.down
    remove_index :mbos,:department_id
    remove_index :mbos,:ownerid
    remove_index :mbos,:starttime
    remove_index :mbos,:endtime
    drop_table :mbos
  end

end