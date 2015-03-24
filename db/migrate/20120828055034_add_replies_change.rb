# 增加项目进度字段

class AddRepliesChange < ActiveRecord::Migration

  def self.up
    rename_column(:replies, :subject_id, :userdaily_id)
    remove_column(:replies, "u_replytype")
  end

  def self.down
    rename_column(:replies, :userdaily_id,:subject_id)
     add_column(:replies, "u_replytype", :integer)
  end

end