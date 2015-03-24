class ReportController < ApplicationController
  unloadable
  before_filter :require_login, :only => [:userindex,:projindex,:managerindex]
  
   
  def userindex
    #@mboss = Mbo.find(:all,:conditions =>"ownerid=#{User.current.id} AND DATE_FORMAT(starttime,'%Y-%m')=DATE_FORMAT(NOW(),'%Y-%m')", :order => 'created_at DESC')
    @mbos = User.find(User.current.id).mbos.find(:all,:conditions =>"DATE_FORMAT(starttime,'%Y-%m')=DATE_FORMAT(NOW(),'%Y-%m')", :order => 'created_at DESC')
    puts "###################################"
    puts @mbos
    puts "###################################"
    
#     @mbos.each do |mbo|
#       puts mbo
#     end
#
    @userdailes = Userdaily.find(:all,:conditions =>"user_id=#{User.current.id}", :order => 'created_at DESC',:limit=>5)
    @weeklydailes = Weeklydaily.find(:all,:conditions =>"user_id=#{User.current.id} AND date_format(created_at,'%Y-%m')=date_format(now(),'%Y-%m')", :order => 'created_at DESC')

  end



  def projindex
  
    # @projdailyheads = Projdailyhead.find(:all,:select=>'id,user_id,user_name,MAX(pd_date) as pd_date,pd_name,pd_isdelay,pd_help,pd_risk,pd_totalproportion', :order => "pd_date DESC",:limit=>15,:group => "pd_name")
    @url ='http://192.168.168.250/confluence/pages/viewpage.action?pageId=1277958'
    redirect_to @url
  end


  def managerindex

    
    #@projdailyheads = Projdailyhead.find(:all,:select=>'id,user_id,user_name,MAX(pd_date) as pd_date,pd_name,pd_isdelay,pd_help,pd_risk,pd_totalproportion', :order => "pd_date DESC",:limit=>15,:group => "pd_name")
    @id = User.current.id
    @tm = Team.find(:first,:conditions =>"competendid=#{User.current.id} AND status=2")
    if @tm != nil
      @tmi = @tm.competendid
      @userdailes = daily_manager
      
      @weeklydailes = weekly_manager
    else
      @tmi = @tm
      # 查询指定部门数据
      @team = Team.find(:first,:conditions =>"competendid=#{User.current.id}")
      if @team != nil and @team.competendid.to_s == @id.to_s
        @userdailes = whdaily
        @weeklydailes = whweekly
      end
    end

  end
   


  private
  def whdaily
    @wsql = ""
    @team = Team.find(:first,:conditions =>"competendid=#{User.current.id}")

    unless @team.nil?
      @team.users.each do |us|
        @wsql << " OR user_id=#{us.id} AND YEARWEEK(DATE_FORMAT(created_at,'%Y-%m-%d')) = YEARWEEK(NOW())"
      end
      @wsql =@wsql[4..@wsql.length]
      #      puts "##############weekly##################"
      #      puts @wsql
      #      puts "##############weekly##################"
      @dailes = Userdaily.find(:all,:conditions =>@wsql, :order => 'created_at DESC')
      
    else
      flash[:notice] = "查询失败！"
      #      puts "no groupusers"
    end
  end


  def whweekly

    @wsql = ""

    @team = Team.find(:first,:conditions =>"competendid=#{User.current.id}")
    unless @team.nil?
      @team.users.each do |us|
        @wsql << " OR user_id=#{us.id} AND date_format(created_at,'%Y-%m')=date_format(now(),'%Y-%m')"
      end
      @wsql =@wsql[4..@wsql.length]
      #      puts "##############weekly##################"
      #      puts @wsql
      #      puts "##############weekly##################"
      @weekly = Weeklydaily.find(:all,:conditions =>@wsql, :order => 'created_at DESC')
    else
      flash[:notice] = "查询失败！"
    end

  end

  def daily_manager
 
 
    @dailes = Userdaily.find(:all, :order => 'ud_deptname DESC')

  end
  
  def weekly_manager
 
    @weeklys = Weeklydaily.find(:all, :order => 'wd_deptname DESC')
 
  end
end
