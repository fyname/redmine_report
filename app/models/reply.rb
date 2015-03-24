class Reply < ActiveRecord::Base
  unloadable
  belongs_to :projdailyheads
  belongs_to :userdailies
  belongs_to :weeklydailies
end
