# 增加任务是否完成字段

class AddProjdailytasksIscomplete < ActiveRecord::Migration

  def self.up
    add_column(:projdailytasks, "pd_iscomplete", :string)
    change_column(:projdailytasks, :pd_proportion, :integer)
  end

  def self.down
    remove_column(:projdailytasks, "pd_iscomplete")
    change_column(:projdailytasks, :pd_proportion, :string)
  end

end