class Team < ActiveRecord::Base
  unloadable

  #has_and_belongs_to_many :users, :after_add => :user_added,
  #                                :after_remove => :user_removed
  has_and_belongs_to_many :users
  #validates_presence_of :id,:name,:competendid,:organizationid
  validates_presence_of :name,:competendid,:status
end
