class MboController < ApplicationController
  unloadable

  before_filter :require_login, :only => [:index, :show, :list, :new,:create,:edit,:update,:destroy,:managerlist,:ownerlist]
 
  def index
    #@mbos = Mbo.find(:all,:order => 'team_id')
    #@team = Team.find(:first,:conditions =>"competendid=#{User.current.id} and status=2")
    #if @team
    @mbos = Mbo.find(:all,:order => 'created_at')
    #else
    #      @ambo = Array.new
    @teams = Team.find(:first,:conditions =>"competendid=#{User.current.id}")
    #      if @team != nil
    #        @users = User.find(@team.users)
    #        @users.each do |us|
    #          us.mbos.each do |mbo|
    #            @ambo << mbo
    #          end
    #        end
    #
    #        @mbos = @ambo.uniq
    #      else
    #        @mbos = nil
    #      end

    #end
  end

  def show

    @user = Array.new

    @tid = Team.find(:first,:select=>"id,competendid",:conditions =>"competendid=#{User.current.id} and status=2")
    if @tid != nil
      @td = @tid.competendid.to_s
    else
      @td = nil
    end
    @userid = User.current.id.to_s
    if  @userid == @td
      @users = @tid.users
      #@users =User.active.find(:all,:conditions =>"")
      @teams = Team.find(:all,:select=>'id,name')
    else
      @team = Team.find(:first,:select=>"id",:conditions =>"competendid=#{User.current.id}")
      #@users =User.find(:all,:conditions =>"team_id=#{@team.id}")
      if @team != nil
        @users = @team.users
      else
        @users = nil
      end
      @teams = Team.find(:all,:select=>'id,name',:conditions =>"competendid=#{User.current.id}")
    end

    @mbo = Mbo.find(params[:id])
  end
  
  
  def managerlist
    @team = session[:team]
    @starttime =session[:starttime]
    @endtime = session[:endtime] 
  end

  def new
    @tid = Team.find(:first,:select=>"id,competendid",:conditions =>"competendid=#{User.current.id} and status=2")
    if @tid != nil
      @td = @tid.competendid.to_s
    else
      @td = nil
    end
    @userid = User.current.id.to_s
    if  @userid == @td
      @users = @tid.users
      #@users =User.active.find(:all,:conditions =>"")
      @teams = Team.find(:all,:select=>'id,name')
    else
      @team = Team.find(:first,:select=>"id",:conditions =>"competendid=#{User.current.id}")
      #@users =User.find(:all,:conditions =>"team_id=#{@team.id}")
      @users = @team.users
      @teams = Team.find(:all,:select=>'id,name',:conditions =>"competendid=#{User.current.id}")
    end

    @mbo =  Mbo.new
  end

  def edit

    @tid = Team.find(:first,:select=>"id,competendid",:conditions =>"competendid=#{User.current.id} and status=2")
    if @tid != nil
      @td = @tid.competendid.to_s
    else
      @td = nil
    end
    @userid = User.current.id.to_s
    if  @userid == @td
      @users = @tid.users
      #@users =User.active.find(:all,:conditions =>"")
      @teams = Team.find(:all,:select=>'id,name')
    else
      @team = Team.find(:first,:select=>"id",:conditions =>"competendid=#{User.current.id}")
      #@users =User.find(:all,:conditions =>"team_id=#{@team.id}")
      if @team != nil 
        @users = @team.users
      end
      
      @teams = Team.find(:all,:select=>'id,name',:conditions =>"competendid=#{User.current.id}")
    end

    @mbo =  Mbo.find(params[:id])
  end


  def create
    puts "#######################################"
    puts params[:mbo][:team_id]
    #puts params[:mbo][:ownerid]
    puts User.current.id
    puts params[:mbo][:content]
    puts params[:mbo][:starttime]
    puts params[:mbo][:endtime]
    puts params[:mbo][:iscomplete]
    puts params[:mbo][:remark]
    puts "#######################################"
    @mbo =  Mbo.create(
      :team_id=>params[:mbo][:team_id],
      #:ownerid=>params[:mbo][:ownerid],
      :createuserid=>User.current.id,
      :updateuserid=>User.current.id,
      :content=>params[:mbo][:content],
      :starttime=>params[:mbo][:starttime],
      :endtime=>params[:mbo][:endtime],
      :iscomplete=>params[:mbo][:iscomplete],
      :remark=>params[:mbo][:remark]
    )
    if @mbo.save
      flash[:notice] = "生成目标成功！"
      redirect_to({ :controller => 'mbo', :action => 'index' })
    else
      flash[:notice] = "生成目标失败！"
      redirect_to({ :controller => 'mbo', :action => 'new' })
    end
  end

  def update
    puts "#######################################"
    puts params[:mbo][:team_id]
    puts params[:mbo][:ownerid]
    puts User.current.id
    puts params[:mbo][:content]
    puts params[:mbo][:starttime]
    puts params[:mbo][:endtime]
    puts params[:mbo][:iscomplete]
    puts params[:mbo][:remark]
    puts "#######################################"
    @mbo = Mbo.find(params[:id])
    if @mbo.update_attributes(
        :team_id=>params[:mbo][:team_id],
        #:ownerid=>params[:mbo][:ownerid],
        :updateuserid=>User.current.id,
        :content=>params[:mbo][:content],
        :starttime=>params[:mbo][:starttime],
        :endtime=>params[:mbo][:endtime],
        :iscomplete=>params[:mbo][:iscomplete],
        :remark=>params[:mbo][:remark]
      )
      flash[:notice] = "修改目标成功！"
      redirect_to({ :controller => 'mbo', :action => 'index' })
    else
      flash[:notice] = "修改目标失败！"
      redirect_to({ :controller => 'mbo', :action => 'index' })
    end 
  end


  def ownerlist

    @mbos = Mbo.find(:all,:conditions =>"ownerid=#{User.current.id} AND DATE_FORMAT(starttime,'%Y-%m')=DATE_FORMAT(NOW(),'%Y-%m')", :order => 'created_at DESC')
    puts "##################################"
    puts @mbos
    puts "##################################"
  end

  def add_users
    @mbo = Mbo.find(params[:id])
    users = User.find_all_by_id(params[:user_ids])
    #puts @team
    #puts @team.sizes
    @mbo.users << users if request.post?
    respond_to do |format|
      format.html { redirect_to :controller => 'mbo', :action => 'edit', :id => @mbo, :tab => 'users' }
      format.js {
        render(:update) {|page|
          page.replace_html "tab-content-users", :partial => 'mbo/users'
          users.each {|user| page.visual_effect(:highlight, "user-#{user.id}") }
        }
      }
    end
  end

  def remove_user
    @mbo = Mbo.find(params[:id])
    @mbo.users.delete(User.find(params[:user_id])) if request.post?
    respond_to do |format|
      format.html { redirect_to :controller => 'mbo', :action => 'edit', :id => @mbo, :tab => 'users' }
      format.js { render(:update) {|page| page.replace_html "tab-content-users", :partial => 'mbo/users'} }
    end
  end

  def autocomplete_for_user
    #@team = Team.find(params[:id])
    @team = Team.find(:first,:select=>"id",:conditions =>"competendid=#{User.current.id}")
    #@users = User.active.like(params[:q]).find(:all, :limit => 100) - @team.users
    @users = @team.users
    render :layout => false
  end


  def search
    @userid = User.current.id
    @starttime = params[:mbo_m_create_at_start]
    @endtime = params[:mbo_m_create_at_end]
    session[:starttime] = @starttime
    session[:endtime] = @endtime
    #@starttime = Date.parse(@starttime)
    #@endtime = Date.parse(@endtime)
    puts "#####################################################"
    puts @starttime
    puts @endtime
    puts "#####################################################"
    #    if @starttime.to_date < @endtime.to_date
    #      flash[:notice] = "开始时间或结束时间！"
    if @starttime ==nil or @endtime ==nil
      @team = nil
      flash[:notice] = "开始时间或结束时间不能为空！"
      redirect_to({ :controller => 'mbo', :action => 'managerlist' })
    else
      @team = Team.find(:first,:select=>'id,name',:conditions =>"competendid=#{@userid}")
      session[:team] = @team
#      puts "########################t#############################"
#      puts @team
#      puts @team.name
#      puts "########################t#############################"
      redirect_to({ :controller => 'mbo', :action => 'managerlist' })

    end

  end
  
end
