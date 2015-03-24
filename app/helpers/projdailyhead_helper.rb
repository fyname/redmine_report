module ProjdailyheadHelper

  # select_project
  def select_project
    # Retrieve them now to avoid a COUNT query
    projects = User.current.projects.all
    if projects.any?
      s = '<select onchange="if (this.value != \'\') { window.location = this.value; }">' +
        "<option value=''>#{ l(:label_jump_to_a_project) }</option>"
      #      s << project_options_for_select(projects, :selected => @project)
      s << project_options_for_select(projects)
      s << '</select>'
      s
    end
  end


  def project_options_for_select(projects, options = {})
    s = ''
    project_tree(projects) do |project, level|
      name_prefix = (level > 0 ? ('&nbsp;' * 2 * level + '&#187; ') : '')
      tag_options = {:value => project.id}
      #      if project == options[:selected] || (options[:selected].respond_to?(:include?) && options[:selected].include?(project))
      #        tag_options[:selected] = 'selected'
      #      else
      #        tag_options[:selected] = nil
      #      end
      tag_options.merge!(yield(project)) if block_given?
      #      s << content_tag('option', name_prefix + h(project), tag_options)
      s << content_tag('option',h(project))
    end
    s
  end
  
end
