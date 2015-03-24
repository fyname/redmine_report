class Weeklydaily < ActiveRecord::Base
  unloadable
  has_many :replies, :dependent => :nullify
  validates_presence_of :user_id,:wd_work,:wd_plan
end
