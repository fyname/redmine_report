module TeamHelper

  def team_settings_tabs
    tabs = [{:name => 'general', :partial => 'team/general', :label => :label_general},
      {:name => 'users', :partial => 'team/users', :label => :label_user_plural},
    ]
  end
end
