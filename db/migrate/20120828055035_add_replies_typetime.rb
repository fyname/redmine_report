# 增加项目进度字段

class AddRepliesTypetime < ActiveRecord::Migration

  def self.up
    change_column(:replies, :u_replytime, :string)
  end

  def self.down
    change_column(:replies, :u_replytime, :datetime)
  end

end