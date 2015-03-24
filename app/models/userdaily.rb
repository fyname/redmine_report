class Userdaily < ActiveRecord::Base
  unloadable

  has_many :replies, :dependent => :nullify
  validates_presence_of :user_id,:ud_work,:ud_plan
end
