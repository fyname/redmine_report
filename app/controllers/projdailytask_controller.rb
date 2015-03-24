class ProjdailytaskController < ApplicationController
  unloadable

  def index
  end

  def show
    session[:prhead_id] =nil
    session[:prhead_id] =params[:pid]
    find_project
    @projdailytask = Projdailytask.find(params[:id])
    @versions = @project.shared_versions || []
    @versions += @project.rolled_up_versions.visible if @with_subprojects
    @versions = @versions.uniq.sort
    @versions.reject! {|version| version.closed? || version.completed? } unless params[:completed]
  end

  def new
    session[:prhead_id] =nil
    session[:prhead_id] =params[:id]
    find_project
    @versions = @project.shared_versions || []
    @versions += @project.rolled_up_versions.visible if @with_subprojects
    @versions = @versions.uniq.sort
    @versions.reject! {|version| version.closed? || version.completed? } unless params[:completed]
    @projdailytask = Projdailytask.new
  end

  def create
    find_project
  
    @done = Projdailyhead.find(:first,:conditions =>"id=#{session[:prhead_id]} AND TO_DAYS(pd_date) = TO_DAYS(NOW())")
    #    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    #    puts @done.id
    #    puts @done.pd_date
    #    puts params[:projdailytask][:pd_module]
    #    puts params[:projdailytask][:pd_isnew]
    #    puts params[:projdailytask][:pd_start]
    #    puts params[:projdailytask][:pd_commitment]
    #    puts params[:projdailytask][:pd_actual]
    #    puts params[:projdailytask][:pd_username]
    #    puts params[:projdailytask][:pd_phase]
    #    puts params[:projdailytask][:pd_version]
    #    puts params[:projdailytask][:pd_proportion]
    #    puts params[:projdailytask][:pd_iscomplete]
    #    puts params[:projdailytask][:pd_delaycause]
    #    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    if @done.id !=nil
      @projdailytask = Projdailytask.create(
        :projdailyhead_id=>@done.id,
        :pd_module=>params[:projdailytask][:pd_module],
        :pd_isnew=>params[:projdailytask][:pd_isnew],
        :pd_start=>params[:projdailytask][:pd_start],
        :pd_commitment=>params[:projdailytask][:pd_commitment],
        :pd_actual=>params[:projdailytask][:pd_actual],
        :pd_delaytime=> @pd_delaytime,
        :pd_delaycause=>params[:projdailytask][:pd_delaycause],
        :pd_username=>params[:projdailytask][:pd_username],
        :pd_phase=>params[:projdailytask][:pd_phase],
        :pd_version=>params[:projdailytask][:pd_version],
        :pd_proportion=>params[:projdailytask][:pd_proportion],
        :pd_iscomplete=>params[:projdailytask][:pd_iscomplete]
      )
      if @projdailytask.save
    
        @total =Projdailytask.all(:select => "AVG(pd_proportion) as avg_proportion",:conditions =>"projdailyhead_id=#{@projdailytask.projdailyhead_id}")
        @done = Projdailyhead.find(:first,:conditions =>"id=#{@projdailytask.projdailyhead_id}")
        #      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        #      puts @total.first.avg_proportion.to_s.split(".")[0]
        #      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        if @done.update_attributes(:pd_totalproportion=>@total.first.avg_proportion.to_s.split(".")[0])
          puts "update total ok"
        else
          puts "update total fail"
        end
      
        flash[:notice] = "创建项目任务成功！"
        redirect_to({ :controller => 'report', :action => 'projindex' })
      else
        flash[:notice] = "创建项目任务失败！"
        redirect_to({ :controller => 'report', :action => 'projindex' })
      end
    else
      flash[:notice] = "请先创建项目，再创建项目下任务！"
      redirect_to({ :controller => 'report', :action => 'projindex' })
    end
  end

  def edit
    session[:prhead_id] =nil
    session[:prhead_id] =params[:pid]
    find_project
    @versions = @project.shared_versions || []
    @versions += @project.rolled_up_versions.visible if @with_subprojects
    @versions = @versions.uniq.sort
    @versions.reject! {|version| version.closed? || version.completed? } unless params[:completed]
    #    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2"
    #    puts @versions
    #    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2"
    @projdailytask = Projdailytask.find(params[:id])
  end

  def update

    if params[:projdailytask][:pd_actual] !=""
       @pd_dt =DateTime.parse(params[:projdailytask][:pd_actual]) - DateTime.parse(params[:projdailytask][:pd_commitment])
        puts "@@@@@@@@@@@@@@@@pd_dt@@@@@@@@@@@@@@@@@@@@"
        puts @pd_dt
        puts "@@@@@@@@@@@@@@@@pd_dt@@@@@@@@@@@@@@@@@@@@"
      if @pd_dt > 0 and params[:projdailytask][:pd_delaycause] == ""
        flash[:notice] = "【实际完成时间大于承诺时间】任务延迟原因不能为空！"
        redirect_to({ :controller => 'report', :action => 'projindex' })
      else
        @pd_determine =DateTime.parse(params[:projdailytask][:pd_actual]) - DateTime.parse(params[:projdailytask][:pd_commitment])
        @d = DateTime.now
        @count = 0
        @pd_determine.to_i.times do|i|
          # puts @d
          if  @d.wday == 0 or  @d.wday ==6
            @count+=1
            puts @d.strftime('%Y-%m-%d')
          end
          @d += 1
        end

        @pd_delaytime =@pd_determine -@count
        
        puts "@@@@@@@@@@@@@@@@pd_delaytime@@@@@@@@@@@@@@@@@@@@"
        puts @pd_delaytime
        puts "@@@@@@@@@@@@@@@pd_delaytime@@@@@@@@@@@@@@@@@@@@@"

        @projdailytask = Projdailytask.find(params[:id])
        #    puts "##########################"
        #    puts @userdaily
        #    puts params[:userdaily][:ud_work]
        #    puts params[:userdaily][:ud_plan]
        #    puts params[:userdaily][:ud_proposal]
        #    puts params[:userdaily][:ud_probles]
        #    puts "##########################"
        if  @projdailytask.update_attributes(
            :pd_module=>params[:projdailytask][:pd_module],
            :pd_isnew=>params[:projdailytask][:pd_isnew],
            :pd_commitment=>params[:projdailytask][:pd_commitment],
            :pd_actual=>params[:projdailytask][:pd_actual],
            :pd_delaytime=>@pd_delaytime,
            :pd_delaycause=>params[:projdailytask][:pd_delaycause],
            :pd_username=>params[:projdailytask][:pd_username],
            :pd_phase=>params[:projdailytask][:pd_phase],
            :pd_version=>params[:projdailytask][:pd_version],
            :pd_proportion=>params[:projdailytask][:pd_proportion],
            :pd_iscomplete=>params[:projdailytask][:pd_iscomplete]
          )

          @total =Projdailytask.all(:select => "AVG(pd_proportion) as avg_proportion",:conditions =>"projdailyhead_id=#{@projdailytask.projdailyhead_id}")
          @done = Projdailyhead.find(:first,:conditions =>"id=#{@projdailytask.projdailyhead_id}")
          #      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
          #      puts @total.first.avg_proportion.to_s.split(".")[0]
          #      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
          if @done.update_attributes(:pd_totalproportion=>@total.first.avg_proportion.to_s.split(".")[0])
            puts "update total ok"
          else
            puts "update total fail"
          end
          flash[:notice] = "修改成功！"
          redirect_to({ :controller => 'report', :action => 'projindex' })
        else
          flash[:notice] = "修改失败！"
          redirect_to({ :controller => 'report', :action => 'projindex' })
        end
      end

    else
      @projdailytask = Projdailytask.find(params[:id])
      #    puts "##########################"
      #    puts @userdaily
      #    puts params[:userdaily][:ud_work]
      #    puts params[:userdaily][:ud_plan]
      #    puts params[:userdaily][:ud_proposal]
      #    puts params[:userdaily][:ud_probles]
      #    puts "##########################"
      if  @projdailytask.update_attributes(
            :pd_module=>params[:projdailytask][:pd_module],
            :pd_isnew=>params[:projdailytask][:pd_isnew],
            :pd_commitment=>params[:projdailytask][:pd_commitment],
            :pd_actual=>params[:projdailytask][:pd_actual],
            :pd_delaytime=>@pd_delaytime,
            :pd_delaycause=>params[:projdailytask][:pd_delaycause],
            :pd_username=>params[:projdailytask][:pd_username],
            :pd_phase=>params[:projdailytask][:pd_phase],
            :pd_version=>params[:projdailytask][:pd_version],
            :pd_proportion=>params[:projdailytask][:pd_proportion],
            :pd_iscomplete=>params[:projdailytask][:pd_iscomplete]
        )

        @total =Projdailytask.all(:select => "AVG(pd_proportion) as avg_proportion",:conditions =>"projdailyhead_id=#{@projdailytask.projdailyhead_id}")
        @done = Projdailyhead.find(:first,:conditions =>"id=#{@projdailytask.projdailyhead_id}")
        #      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        #      puts @total.first.avg_proportion.to_s.split(".")[0]
        #      puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        if @done.update_attributes(:pd_totalproportion=>@total.first.avg_proportion.to_s.split(".")[0])
          puts "update total ok"
        else
          puts "update total fail"
        end
        flash[:notice] = "修改成功！"
        redirect_to({ :controller => 'report', :action => 'projindex' })
      else
        flash[:notice] = "修改失败！"
        redirect_to({ :controller => 'report', :action => 'projindex' })
      end
    end
  end



  def destroy


  end


  private
  def find_project
    #    @done = Projdailyhead.find(:first,:conditions =>"user_id=#{User.current.id} AND TO_DAYS(pd_date) = TO_DAYS(NOW())")
    @done = Projdailyhead.find(session[:prhead_id])
    @project = Project.find(@done.pd_name.to_s.split("|")[0])
    puts "################################"
    puts @project
    puts "################################"
  rescue ActiveRecord::RecordNotFound
    render_404
  end


  def determine_date
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    puts params[:projdailytask][:pd_actual]
    puts params[:projdailytask][:pd_commitment]
    puts  params[:projdailytask][:pd_delaycause]
    puts DateTime.parse(params[:projdailytask][:pd_actual])
    puts DateTime.parse(params[:projdailytask][:pd_commitment])
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    if params[:projdailytask][:pd_actual] !=""
      if params[:projdailytask][:pd_delaycause] ==""
        flash[:notice] = "任务延迟原因不能为空！"
        puts "任务延迟原因不能为空！"
        render  :action => 'edit',:id=>params[:id] and return
      else
        @pd_determine =DateTime.parse(params[:projdailytask][:pd_actual]) - DateTime.parse(params[:projdailytask][:pd_commitment])
        @d = DateTime.now
        @count = 0
        @pd_determine.to_i.times do|i|
          # puts @d
          if  @d.wday == 0 or  @d.wday ==6
            @count+=1
            puts @d.strftime('%Y-%m-%d')
          end
          @d += 1
        end

        @pd_delaytime =@pd_determine -@count
      end

    end
  end
end
