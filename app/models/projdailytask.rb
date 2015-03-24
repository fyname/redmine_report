class Projdailytask < ActiveRecord::Base
  unloadable

  belongs_to :projdailyheads

  validates_presence_of :projdailyhead_id,:pd_module,:pd_isnew,:pd_start,:pd_commitment,:pd_phase,:pd_username,:pd_version,:pd_proportion,:pd_iscomplete
end
