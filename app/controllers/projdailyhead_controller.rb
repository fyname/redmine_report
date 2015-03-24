class ProjdailyheadController < ApplicationController
  unloadable


  def index
  end

  def show
    @projdailyhead = Projdailyhead.find(params[:id])
  end

  def list

    @projdailyheads = Projdailyhead.find(:all,:conditions =>"user_id=#{User.current.id} AND YEARWEEK(DATE_FORMAT(pd_date,'%Y-%m-%d')) = YEARWEEK(NOW())", :order => 'pd_date DESC')
  end

=begin
   显示该用户昨天的填写数据
=end
  def new
    @done = Projdailyhead.find(:first,:conditions =>"user_id=#{User.current.id} AND TO_DAYS(pd_date) = TO_DAYS(NOW())")
    if @done !=nil
      #      @projdailyhead = Projdailyhead.new
      @projdailyhead = @done
      puts "################now#########################"
      puts @projdailyhead
      puts "################now#########################"
    else
      @projdailyhead = Projdailyhead.new
      @pdh = Projdailyhead.find(:first,:conditions =>"user_id=#{User.current.id} AND (TO_DAYS(NOW())-TO_DAYS(pd_date))<= 1")
      if @pdh !=nil
        @projdailyhead =@pdh
      else
        puts "new task"
      end
    end

  end

  def create
    @done = Projdailyhead.find(:first,:conditions =>"pd_name='#{params[:projdailyhead][:pd_name]}' AND TO_DAYS(pd_date) = TO_DAYS(NOW())", :order => 'pd_date DESC')
    #    puts "2222222222222222222222222"
    #    puts User.current.to_s
    #    puts User.current.id
    #    puts "2222222222222222222222222"
    if  @done ==nil
      @projhead = Projdailyhead.create(:user_id=>User.current.id,
        :user_name=>User.current.to_s,
        :pd_date=>Date.today.to_s,
        :pd_name=>params[:projdailyhead][:pd_name],
        :pd_isdelay=>params[:projdailyhead][:pd_isdelay],
        :pd_help=>params[:projdailyhead][:pd_help],
        :pd_risk=>params[:projdailyhead][:pd_risk])
      if @projhead.save
        flash[:notice] = "创建项目日报成功！"
        redirect_to({ :controller => 'report', :action => 'projindex' })
      else
        flash[:notice] = "创建项目日报失败！"
        redirect_to({ :controller => 'report', :action => 'projindex' })
      end

      @projdailyhead = Projdailyhead.find(:first,:conditions =>"pd_name='#{params[:projdailyhead][:pd_name]}'", :order => 'pd_date DESC', :offset => 1)
      if @projdailyhead !=nil
        @projdailyhead.projdailytasks.each do |ph|
          #          puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
          #          puts ph.pd_username
          #          puts ph.pd_module
          #          puts ph.pd_isnew
          #          puts ph.pd_commitment.to_s
          #          puts ph.pd_phase
          #          puts ph.pd_version
          #          puts ph.pd_proportion
          #          puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
          @projdailytask = Projdailytask.create(
            :projdailyhead_id=>@projhead.id,
            :pd_module=>ph.pd_module,
            :pd_isnew=>ph.pd_isnew,
            :pd_start=>ph.pd_start,
            :pd_commitment=>ph.pd_commitment,
            :pd_actual=>ph.pd_actual,
            :pd_username=>ph.pd_username,
            :pd_phase=>ph.pd_phase,
            :pd_version=>ph.pd_version,
            :pd_proportion=>ph.pd_proportion,
            :pd_iscomplete=>ph.pd_iscomplete
          )
          if @projdailytask.save
            flash[:notice] = "创建项目任务成功！"
            @total =Projdailytask.all(:select => "AVG(pd_proportion) as avg_proportion",:conditions =>"projdailyhead_id=#{@projdailyhead.id}")
            @done = Projdailyhead.find(:first,:conditions =>"id=#{@projhead.id}")
            #      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
            #      puts @total.first.avg_proportion.to_s.split(".")[0]
            #      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
            if @done.update_attributes(:pd_totalproportion=>@total.first.avg_proportion.to_s.split(".")[0])
              puts "update total ok"
            else
              puts "update total fail"
            end
            #            redirect_to({ :controller => 'report', :action => 'projindex' })
          else
            flash[:notice] = "创建项目任务失败！"
            #            redirect_to({ :controller => 'report', :action => 'projindex' })
          end
        end
      else
        puts "创建项目任务部分失败"
      end

    else
      flash[:notice] = "项目日报已经创建！"
      redirect_to({ :controller => 'report', :action => 'projindex' })

    end
  end

  def edit
    @projdailyhead = Projdailyhead.find(params[:id])
  end

  def update
    @projdailyhead = Projdailyhead.find(params[:id])
    #    puts "##########################"
    #    puts @userdaily
    #    puts params[:userdaily][:ud_work]
    #    puts params[:userdaily][:ud_plan]
    #    puts params[:userdaily][:ud_proposal]
    #    puts params[:userdaily][:ud_probles]
    #    puts "##########################"
    if  @projdailyhead.update_attributes(:pd_name=>params[:projdailyhead][:pd_name],
        :pd_isdelay=>params[:projdailyhead][:pd_isdelay],
        :pd_help=>params[:projdailyhead][:pd_help],
        :pd_risk=>params[:projdailyhead][:pd_risk]
      )
      flash[:notice] = "修改成功！"
      redirect_to({ :controller => 'report', :action => 'projindex' })
    else
      flash[:notice] = "修改失败！"
      redirect_to({ :controller => 'report', :action => 'projindex' })
    end
  end

  def destroy
  end
end
