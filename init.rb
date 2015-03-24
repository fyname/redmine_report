require 'redmine'

Redmine::Plugin.register :redmine_reports do
  name 'redmine report'
  author '杨飞'
  description '这是一个报告生成工具包括日报周报，项目报告,组织结构,目标管理'
  version '1.0.5'
  url 'http://freesun.eicp.net'
  author_url 'http://freesun.eicp.net'


  menu :application_menu, :Reportuser, { :controller => 'report', :action => 'userindex' }, :caption => :report_user_title,
    :if =>  Proc.new {User.current.logged?}

  menu :application_menu, :Reportproj, { :controller => 'report', :action => 'projindex' }, :caption =>:report_project_title,
    :if =>  Proc.new {User.current.logged?}

  menu :application_menu, :Reportmanager, { :controller => 'report', :action => 'managerindex' }, :caption =>:report_manager_title,
    :if =>  Proc.new {User.current.logged?}

  menu :application_menu, :Reportmbo, { :controller => 'mbo', :action => 'index' }, :caption =>:report_mbo_title,
    :if =>  Proc.new {User.current.logged?}
  
  #project_module :report do
    permission :view_team, {
      'team' => [:index, :show, :list, :new,:create,:edit,:update,:destroy,:add_users,:remove_user,:autocomplete_for_user]
    }
    permission :view_mbo, {
      'mbo' => [:index, :show, :list, :new,:create,:edit,:update,:destroy,:managerlist,:ownerlist]
    }
    permission :view_report, {
      'mbo' => [:userindex,:projindex,:managerindex]
    }
  #end

end
