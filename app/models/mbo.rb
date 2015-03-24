class Mbo < ActiveRecord::Base
  unloadable

  has_and_belongs_to_many :users
  #validates_presence_of :team_id,:ownerid,:createuserid,:updateuserid,:content,:starttime,:endtime,:iscomplete
  validates_presence_of :team_id,:updateuserid,:content,:starttime,:endtime
end
