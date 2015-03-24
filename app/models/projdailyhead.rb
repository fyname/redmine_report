class Projdailyhead < ActiveRecord::Base
  unloadable

  has_many :projdailytasks, :dependent => :nullify
  has_many :projdailyschedules, :dependent => :nullify
  has_many :replies, :dependent => :nullify

  validates_presence_of :user_id,:user_name,:pd_date,:pd_name,:pd_isdelay
  
end
