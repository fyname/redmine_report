# 增加延迟原因字段

class AddProjdailytasksDelaycause < ActiveRecord::Migration

  def self.up
    add_column(:projdailytasks, "pd_delaycause", :text)
  end

  def self.down
    remove_column(:projdailytasks, "pd_delaycause")
  end

end