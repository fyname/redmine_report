# 团队表

class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.column :name, :string          #团队名称
      t.column :remark, :text          #备注
      t.column :competendid, :integer  #团队主管id
      t.column :status, :integer       #团队类型，0集团,1公司，2总经办,3部门经理,4组长
      t.timestamps
    end

     add_index :teams,:name                            #创建普通索引
     add_index :teams,:competendid                     #创建普通索引
  end

  def self.down
    remove_index :teams,:name
    remove_index :teams,:competendid
    drop_table :teams
  end
end
