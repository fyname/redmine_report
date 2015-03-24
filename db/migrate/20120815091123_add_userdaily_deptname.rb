# 增加部门字段

class AddUserdailyDeptname < ActiveRecord::Migration

  def self.up
    add_column(:userdailies, "ud_deptname", :string)
  end

  def self.down
    remove_column(:userdailies, "ud_deptname")
  end
end
