class ProjdailyscheduleController < ApplicationController
  unloadable
  

  def index
  end

  def show
    find_project
    @projdailyschedule = Projdailyschedule.find(params[:id])
  end


  def list
    @pdh = Projdailyschedule.find(:first,:conditions =>"user_id=#{User.current.id} AND TO_DAYS(pd_date) = TO_DAYS(NOW())", :order => 'created_at DESC')
  end

  def new
    session[:prhead_id] =params[:id]
    find_project
    @versions = @project.shared_versions || []
    @versions += @project.rolled_up_versions.visible if @with_subprojects
    @versions = @versions.uniq.sort
    @versions.reject! {|version| version.closed? || version.completed? } unless params[:completed]
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2"
    puts @versions
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2"
    @projdailyschedule = Projdailyschedule.new
  end



  def create

    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    @pv =params[:projdailyschedule][:pd_version].to_s.split("|")[0]
    @pid= params[:projdailyschedule][:pd_bugs].to_s.split("|")[0]
    puts @pv
    puts @pid
    puts  params[:projdailyschedule][:pd_version]
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    @done = Projdailyhead.find(:first,:conditions =>"id=#{session[:prhead_id]} AND TO_DAYS(pd_date) = TO_DAYS(NOW())")
    session[:prhead_id] =nil
    if  params[:projdailyschedule][:pd_version]!=nil
      @pdc = Projdailyschedule.find(:first,:conditions =>"pd_version='#{params[:projdailyschedule][:pd_version].to_s}' and projdailyhead_id=#{@done.id}")
      if params[:projdailyschedule][:pd_version] == ""
        @sql = "SELECT issues.id,issues.subject  FROM `issues` LEFT OUTER JOIN `issue_statuses` ON `issue_statuses`.id = `issues`.status_id WHERE (is_closed = 0 AND project_id = #{@pid})"
      else
        @sql = "SELECT issues.id,issues.subject  FROM `issues` LEFT OUTER JOIN `issue_statuses` ON `issue_statuses`.id = `issues`.status_id WHERE (fixed_version_id = #{@pv} AND is_closed = 0 AND project_id = #{@pid})"
      end
     
      @issues = Issue.find_by_sql(@sql)
      if @issues.length == 0
        @issues = "该版本暂没关联问题"
      end
      puts "@@@@@@@@@@@@@@@@@@@@is@@@@@@@@@@@@@@@@@@@@@@@@@@@"
      puts @issues.length
      puts "@@@@@@@@@@@@@@@@@@@is@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

      if @pdc == nil
        if params[:projdailyschedule][:pd_version] !=""
          @projdailyschedule = Projdailyschedule.create(:projdailyhead_id=>@done.id,:pd_version=>params[:projdailyschedule][:pd_version],:pd_bugs=>@issues.to_s)
        else
          @projdailyschedule = Projdailyschedule.create(:projdailyhead_id=>@done.id,:pd_bugs=>@issues.to_s)
        end
        
        if @projdailyschedule.save
          flash[:notice] = "创建项目问题成功！"
          redirect_to({ :controller => 'report', :action => 'projindex' })
        else
          flash[:notice] = "创建项目问题失败！"
          redirect_to({ :controller => 'report', :action => 'projindex' })
        end

      else
        if @pdc.update_attributes(:pd_bugs=>@issues.to_s)
          flash[:notice] = "创建项目问题成功！"
          redirect_to({ :controller => 'report', :action => 'projindex' })
          puts "version ok"
        else
          flash[:notice] = "创建项目问题失败！"
          redirect_to({ :controller => 'report', :action => 'projindex' })
          puts "version faile"
        end
      end

    else
      @projdailyschedule = Projdailyschedule.create(:projdailyhead_id=>@done.id,:pd_bugs=>@issues.to_s)
      if @projdailyschedule.save
        flash[:notice] = "创建项目问题成功！"
        redirect_to({ :controller => 'report', :action => 'projindex' })
      else
        flash[:notice] = "创建项目问题失败！"
        redirect_to({ :controller => 'report', :action => 'projindex' })
      end
    end

      
  end

  def edit

  end

  def update

  end

  def destroy
  end


  private
  def find_project
    #    @project = Project.find(params[:project_id])
    @done = Projdailyhead.find(:first,:conditions =>"user_id=#{User.current.id} AND TO_DAYS(pd_date) = TO_DAYS(NOW())")
    @project = Project.find(@done.pd_name.to_s.split("|")[0])
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    puts @project
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

  rescue ActiveRecord::RecordNotFound
    render_404
  end
  #
  #  def retrieve_selected_tracker_ids(selectable_trackers, default_trackers=nil)
  #    if ids = params[:tracker_ids]
  #      @selected_tracker_ids = (ids.is_a? Array) ? ids.collect { |id| id.to_i.to_s } : ids.split('/').collect { |id| id.to_i.to_s }
  #    else
  #      @selected_tracker_ids = (default_trackers || selectable_trackers).collect {|t| t.id.to_s }
  #    end
  #  end
end
