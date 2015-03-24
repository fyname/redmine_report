module MboHelper

  def mbo_settings_tabs
    tabs = [{:name => 'general', :partial => 'mbo/general', :label => :label_general},
      {:name => 'users', :partial => 'mbo/users', :label => :label_user_plural},
    ]
  end

end
