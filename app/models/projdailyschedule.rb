class Projdailyschedule < ActiveRecord::Base
  unloadable

  belongs_to :projdailyheads
#  belongs_to :project
  validates_presence_of :pd_bugs

#    # Versions that the issue can be assigned to
#  def assignable_versions
#    @assignable_versions ||= (project.shared_versions.open + [Version.find_by_id(fixed_version_id_was)]).compact.uniq.sort
#  end
end
