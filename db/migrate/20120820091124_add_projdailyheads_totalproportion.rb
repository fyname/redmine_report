# 增加项目进度字段

class AddProjdailyheadsTotalproportion < ActiveRecord::Migration

  def self.up
    add_column(:projdailyheads, "pd_totalproportion", :integer)
  end

  def self.down
    remove_column(:projdailyheads, "pd_totalproportion")
  end
  
end