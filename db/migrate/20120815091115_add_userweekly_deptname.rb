# 增加部门字段

class AddUserweeklyDeptname < ActiveRecord::Migration

  def self.up
    add_column(:weeklydailies, "wd_deptname", :string)
  end

  def self.down
    remove_column(:weeklydailies, "wd_deptname")
  end
end
