# 增加时间和作者字段

class AddUserdailyNameTime < ActiveRecord::Migration
 
  def self.up
    add_column(:userdailies, "user_name", :string)
    add_column(:userdailies, "create_weekly", :string)
  end

  def self.down
    remove_column(:userdailies, "user_name")
    remove_column(:userdailies, "create_weekly")
  end
end
