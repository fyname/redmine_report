# 删除目标所有者字段

class AddMbosDelowner < ActiveRecord::Migration

   def self.up
    remove_column(:mbos, "ownerid")
  end

  def self.down
    add_column(:mbos, "ownerid", :integer)
  end

end