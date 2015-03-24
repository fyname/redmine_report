class WeeklydailyController < ApplicationController
  unloadable


  before_filter :require_login, :only => [:index, :show, :list, :new,:create,:edit,:update,:destroy]
  def index
    #@weeklydailes = Weeklydaily.find(:all,:order => 'created_at DESC')
    @weeklydailes = session[:weeklydailes]
  end


  def show
    @weeklydaily = Weeklydaily.find(params[:id])
  end

  def search
    
    @userid = User.current.id
    @starttime = params[:weeklydaily_w_create_at_start]
    @endtime = params[:weeklydaily_w_create_at_end]
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
      redirect_to({ :controller => 'weeklydaily', :action => 'index' })
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
        @weeklydailes = Weeklydaily.find(:all,:conditions =>@wsql, :order => 'user_id DESC')
        session[:weeklydailes] = @weeklydailes
        redirect_to({ :controller => 'weeklydaily', :action => 'index' })
      else
        @weeklydailes = Weeklydaily.find(:all,:conditions => ["user_id= ? and (created_at >= ? and created_at <= ?)",@userid, @starttime, @endtime] )
        session[:weeklydailes] = @weeklydailes
        redirect_to({ :controller => 'weeklydaily', :action => 'index' })
      end
    end

  end


  def list
    @weeklydailes = Weeklydaily.find(:all,:conditions =>"user_id=#{User.current.id} AND date_format(created_at,'%Y-%m')=date_format(now(),'%Y-%m')", :order => 'created_at DESC')
  end

  def mlist
    
  end

  def new
    @Weeklydaily = Weeklydaily.new
  end

  def create

    @defouttext ="请修改并完善"
    @user = User.find(User.current.id)
    @tname = @user.teams.find(:first,:conditions =>"status=3")
    @done = Weeklydaily.find(:first,:conditions =>"user_id=#{User.current.id} AND YEARWEEK(DATE_FORMAT(created_at,'%Y-%m-%d')) = YEARWEEK(NOW())", :order => 'created_at DESC')

    #    puts "##########################"
    #    puts @done
    #    puts params[:weeklydaily][:wd_work]
    #    puts params[:weeklydaily][:wd_plan]
    #    puts params[:weeklydaily][:wd_proposal]
    #    puts params[:weeklydaily][:wd_probles]
    #    puts "##########################"
    #    puts "2222222222222222222222222"
    #    puts User.current.to_s
    #    puts User.current.id
    #    puts "2222222222222222222222222"

    if @tname==nil
      flash[:notice] = "生成日报失败,请将联系杨飞，#{@user.firstname}加入到组织架构中！"
      redirect_to({ :controller => 'report', :action => 'userindex' })
    else
      @name = @tname.name
      if @done ==nil
        @weeklydaily = Weeklydaily.create(
          :user_id=> User.current.id,
          :user_name=> User.current.to_s,
          :create_weekly=>getweekly,
          :wd_work=>params[:weeklydaily][:wd_work],
          :wd_plan=>params[:weeklydaily][:wd_plan],
          :wd_proposal=>params[:weeklydaily][:wd_proposal],
          :wd_probles=>params[:weeklydaily][:wd_probles],
          :wd_deptname=>@name
        )
        if @weeklydaily.save
          flash[:notice] = "创建周报成功！"
          redirect_to({ :controller => 'report', :action => 'userindex' })
        else
          flash[:notice] = "创建周报失败！"
          redirect_to({ :controller => 'report', :action => 'userindex' })
        end
      else
        @done.update_attributes(
          :create_weekly=>getweekly,
          :wd_work=>params[:weeklydaily][:wd_work],
          :wd_plan=>params[:weeklydaily][:wd_plan],
          :wd_proposal=>params[:weeklydaily][:wd_proposal],
          :wd_probles=>params[:weeklydaily][:wd_probles],
          :wd_deptname=>@name
        )
        flash[:notice] = "个人周报已经创建，一周中只能创建一次，请修改意见创建过周报！"
        redirect_to({ :controller => 'report', :action => 'userindex' })
      end
    end
  end

  def edit
    #puts params[:id]
    #    puts '############################'
    #    puts params[:id]
    #    puts '############################'
    @weeklydaily = Weeklydaily.find(params[:id])
  end

  def update

    @weeklydaily = Weeklydaily.find(params[:id])
    #    puts "##########################"
    #    puts @weeklydaily
    #    puts params[:weeklydaily][:wd_work]
    #    puts params[:weeklydaily][:wd_plan]
    #    puts params[:weeklydaily][:wd_proposal]
    #    puts params[:weeklydaily][:wd_probles]
    #    puts "##########################"

    if  @weeklydaily.update_attributes(:wd_work=>params[:weeklydaily][:wd_work], :wd_plan=>params[:weeklydaily][:wd_plan], :wd_proposal=>params[:weeklydaily][:wd_proposal], :wd_probles=>params[:weeklydaily][:wd_probles])
      flash[:notice] = "修改成功！"
      redirect_to({ :controller => 'report', :action => 'userindex' })
    else
      flash[:notice] = "修改失败！"
      redirect_to({ :controller => 'report', :action => 'userindex' })
    end
  end


  def destroy
    @weeklydaily = Weeklydaily.new
    if @weeklydaily.delete_by?(User.current)
      @weeklydaily = Weeklydaily.find(:first, :conditions => "id = #{params[:id]}")
      @weeklydaily.destroy
      flash[:notice] = "删除成功！"
      redirect_to({ :controller => 'report', :action => 'index' })
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
  
end
