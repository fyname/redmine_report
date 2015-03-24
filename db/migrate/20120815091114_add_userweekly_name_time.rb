# 增加时间和作者字段
class AddUserweeklyNameTime < ActiveRecord::Migration

  def self.up
    add_column(:weeklydailies, "user_name", :string)
    add_column(:weeklydailies, "create_weekly", :string)
  end

  def self.down
    remove_column(:weeklydailies, "user_name")
    remove_column(:weeklydailies, "create_weekly")
  end
end
