class UserdailyController < ApplicationController
  unloadable

  before_filter :require_login, :only => [:index, :show, :list, :new,:create,:edit,:update,:destroy]
  def index
    @userdailes = session[:userdailes]
    #    puts "#####################################################"
    #    puts @userdailes
    #    puts "#####################################################"
  end


  def show
    @userdaily = Userdaily.find(params[:id])
  end



  def search
    @userid = User.current.id
    @starttime = params[:userdaily_d_create_at_start]
    @endtime = params[:userdaily_d_create_at_end]
    #@starttime = Date.parse(@starttime)
    #@endtime = Date.parse(@endtime)
    puts "#####################################################"
    puts @starttime
    puts @endtime
    puts "#####################################################"
    #    if @starttime.to_date < @endtime.to_date
    #      flash[:notice] = "开始时间或结束时间！"
    if @starttime ==nil or @endtime ==nil
      flash[:notice] = "开始时间或结束时间不能为空！"
      redirect_to({ :controller => 'userdaily', :action => 'index' })
    else
      #@userdailes = Userdaily.find(:all,:conditions => ["created_at >= ? and created_at <= ?", @starttime, @endtime])
      @wsql = ""
      @team = Team.find(:first,:conditions =>"competendid=#{@userid}")

      unless @team.nil?
        @team.users.each do |us|
          @wsql << " OR user_id=#{us.id} AND (created_at >= '#{@starttime}' and created_at <= '#{@endtime}')"
        end
        #        puts "##############weekly##################"
        #        puts @wsql
        #        puts"##############weekly##################"
        @wsql =@wsql[4..@wsql.length]
        #        puts "##############weekly##################"
        #        puts @wsql
        #        puts "##############weekly##################"
        @userdailes = Userdaily.find(:all,:conditions =>@wsql, :order => 'user_id DESC')
        session[:userdailes] =@userdailes
        redirect_to({ :controller => 'userdaily', :action => 'index' })
      else
        @userdailes = Userdaily.find(:all,:conditions => ["user_id= ? and (created_at >= ? and created_at <= ?)",@userid, @starttime, @endtime] )
        session[:userdailes] =@userdailes
        redirect_to({ :controller => 'userdaily', :action => 'index' })
      end
    end
    
  end


  def list

    @userdailes = Userdaily.find(:all,:conditions =>"user_id=#{User.current.id} AND YEARWEEK(DATE_FORMAT(created_at,'%Y-%m-%d')) = YEARWEEK(NOW())", :order => 'created_at DESC')
  end

  def slist
    @userdailes = Userdaily.find(:all,:conditions => ["created_at >= ? and created_at <= ?", @@starttime, @@endtime])
  end

  def new
    @userdaily = Userdaily.new
  end

  def create

    @defouttext ="请修改并完善"
    @user = User.find(User.current.id)
    @tname = @user.teams.find(:first,:conditions =>"status=3")
    puts @tname
    if @tname ==nil
      flash[:notice] = "生成日报失败,请将联系杨飞，#{User.current.name}加入到组织架构中！"
      redirect_to({ :controller => 'report', :action => 'userindex' })
    else
      @name =  @tname.name
      @done = Userdaily.find(:first,:conditions =>"user_id=#{User.current.id} AND TO_DAYS(created_at) = TO_DAYS(NOW())", :order => 'created_at DESC')
      #    puts "2222222222222222222222222"
      #    puts User.current.to_s
      #    puts User.current.id
      #    puts "2222222222222222222222222"
      if  @done ==nil
        @userdaily = Userdaily.create(:user_id=>User.current.id,
          :user_name=>User.current.to_s,
          :create_weekly=>getweekly,
          :ud_proposal=>@defouttext,
          :ud_work=>getdata,
          :ud_plan=>@defouttext,
          :ud_probles=>@defouttext,
          :ud_deptname=>@name)
        if @userdaily.save
          flash[:notice] = "生成日报成功！"
          redirect_to({ :controller => 'report', :action => 'userindex' })
        else
          flash[:notice] = "生成日报失败！"
          redirect_to({ :controller => 'report', :action => 'userindex' })
        end
      else
        #      puts "##############2####################"
        #      puts getdata
        #      puts "############2######################"
        #      if  @done.update_attributes(:ud_work=>getdata, :ud_plan=>@defouttext)

        if  @done.update_attributes(:ud_work=>getdata,
            :ud_deptname=>@name)
          flash[:notice] = "重新生成日报成功！"
          redirect_to({ :controller => 'report', :action => 'userindex' })
        else
          flash[:notice] = "重新生成日报失败！"
          redirect_to({ :controller => 'report', :action => 'userindex' })
        end
      end
    end
  end

  def edit

    @userdaily = Userdaily.find(params[:id])
  end

  def update

    @userdaily = Userdaily.find(params[:id])
    puts "##########################"
    puts @userdaily
    puts params[:userdaily][:ud_work]
    puts params[:userdaily][:ud_plan]
    puts params[:userdaily][:ud_proposal]
    puts params[:userdaily][:ud_probles]
    puts params[:userdaily][:create_weekly].to_s
    puts Date.today.to_s
    puts "##########################"

    if params[:userdaily][:create_weekly].to_s == @userdaily.create_weekly.to_s
      if  @userdaily.update_attributes(:create_weekly=>params[:userdaily][:create_weekly],
          :ud_work=>params[:userdaily][:ud_work],
          :ud_plan=>params[:userdaily][:ud_plan],
          :ud_proposal=>params[:userdaily][:ud_proposal],
          :ud_probles=>params[:userdaily][:ud_probles]
        )
        flash[:notice] = "修改成功！"
        redirect_to({ :controller => 'report', :action => 'userindex' })
      else
        flash[:notice] = "修改失败！"
        redirect_to({ :controller => 'report', :action => 'userindex' })
      end
    else
      @userdaily = Userdaily.create(:user_id=>User.current.id,
        :user_name=>User.current.to_s,
        :create_weekly=>params[:userdaily][:create_weekly],
        :ud_proposal=>params[:userdaily][:ud_proposal],
        :ud_work=>params[:userdaily][:ud_work],
        :ud_plan=>params[:userdaily][:ud_plan],
        :ud_probles=>params[:userdaily][:ud_probles],
        :ud_deptname=>@name)
      if @userdaily.save
        flash[:notice] = "生成日报成功！"
        redirect_to({ :controller => 'report', :action => 'userindex' })
      else
        flash[:notice] = "生成日报失败！"
        redirect_to({ :controller => 'report', :action => 'userindex' })
      end
    end
  end


  def destroy
    @userdaily = Userdaily.new
    if @userdaily.delete_by?(User.current)
      @userdaily = Userdaily.find(:first, :conditions => "id = #{params[:id]}")
      @userdaily.destroy
      flash[:notice] = "删除成功！"
      redirect_to({ :controller => 'report', :action => 'userindex' })
    end
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = "该日报不存在！"
    render_404
  end


  private

  def getweekly
    @dayOfWeek = [ "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" ]
    @t = Time.new
    @date =@t.strftime("%Y年%m月%d日 ") << @dayOfWeek[@t.strftime("%w").to_i]
    return @date    #2011年01月29日 星期六
  end

  def getdata
    ####################################start########################################################################

    @mytodayevent =[]
    @days = Setting.activity_days_default.to_i

    @date_to ||= Date.today + 1
    @date_from =Date.today
    @with_subprojects = params[:with_subprojects].nil? ? Setting.display_subprojects_issues? : (params[:with_subprojects] == '1')
    @author = User.active.find(User.current.id)

    @activity = Redmine::Activity::Fetcher.new(User.current, :project => @project,
      :with_subprojects => @with_subprojects,
      :author => @author)

    @Parameters ={"show_news"=>"1", "show_files"=>"1", "show_documents"=>"1","show_changesets"=>"1", "show_messages"=>"1", "show_wiki_edits"=>"1", "show_issues"=>"1"}
    @activity.scope_select {@Parameters.nil?}
    @activity.scope = (@author.nil? ? :default : :all) if @activity.scope.empty?

    @events = @activity.events(@date_from, @date_to)

    @events.each do |e|
      #@mytodayevent <<" 项目名称:#{e.project}，事件名称:#{ e.event_type}#{@template.link_to(e.event_title,e.event_url)}"
      #puts "############################################"
      #        puts e.methods
      #puts e.event_url
      #puts "############################################"
      @mytodayevent <<"【项目:#{e.project} |作者:#{e.event_author}|:#{e.event_title}】"
    end


    ################################################end###################################################################################

    #    puts "####################3########################"
    #    puts @mytodayevent
    #    puts "####################3########################"
    #    puts "####################3########################"
    #    puts @mytodayevent
    #    puts "####################3########################"
    
    if @mytodayevent.length == 0
      @mytodayevent << "请修改并完善"
    end

    #    puts "####################3########################"
    #    puts @mytodayevent
    #    puts "####################3########################"
    return @mytodayevent.to_s
  end
end
