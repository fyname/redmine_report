class CreateReplies < ActiveRecord::Migration
  def self.up
    create_table :replies do |t|
      t.column :subject_id, :integer
      t.column :user_id, :integer
      t.column :user_name, :string
      t.column :u_replycontent, :text
      t.column :u_replytime, :datetime
      t.column :u_replytype, :integer
    end
    add_index :replies,:user_id
    add_index :replies,:subject_id
  end

  def self.down
    remove_index :replies,:subject_id
    remove_index :replies,:user_id
    drop_table :replies
  end
end
