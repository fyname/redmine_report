class TeamController < ApplicationController
  unloadable

  before_filter :require_login, :only => [:index, :show, :list, :new,:create,:edit,:update,:destroy,:add_users,:remove_user,:autocomplete_for_user]
  def index

    @teams = Team.find(:all, :order => 'name')

  end

  def show
    @team = Team.find(params[:id])
    @tid = Team.find(:first,:select=>"id",:conditions =>"competendid=#{User.current.id} and status=1")
    @usernameids = @tid.users
  end

  def list
    @teams = Team.find(:all, :order => 'name')
    @usernameids = User.active.find(:all)
  end

  def new
    @team = Team.new
    #@usernameids =User.active.find(:all,:select=>"id,firstname")
    @usernameids =User.active.find(:all,:select=>"id,firstname").collect{|p| [p.firstname,p.id]}
    #puts @usernameids
  end

  def edit
    @team = Team.find(params[:id])
    #@usernameids = User.active.find(:all)
    @usernameids =User.active.find(:all,:select=>"id,firstname").collect{|p| [p.firstname,p.id]}
    #puts @usernameids.to_a
  end


  def create
    puts "#######################################"
    puts params[:team][:name]
    puts params[:team][:remark]
    puts params[:team][:competendid]
    puts "#######################################"
    @team = Team.create(
      :name=>params[:team][:name],
      :remark=>params[:team][:remark],
      :competendid=>params[:team][:competendid],
      :status=>params[:team][:status]
    )

    if @team.save
      flash[:notice] = "创建成功！"
      redirect_to({ :controller => 'team', :action => 'index' })
    else
      flash[:notice] = "创建失败！"
      redirect_to({ :controller => 'team', :action => 'new' })
    end
  end


  def update
    @team = Team.find(params[:id])
    respond_to do |format|
      if @team.update_attributes(
          :name=>params[:team][:name],
          :remark=>params[:team][:remark],
          :competendid=>params[:team][:competendid],
          :status=>params[:team][:status]
        )

        flash[:notice] = l(:notice_successful_update)

        format.html {redirect_to({ :controller => 'team', :action => 'index' }) }
        format.xml  { head :ok }
      else
        format.html { render :controller => 'team', :action => 'new' }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to({ :controller => 'team', :action => 'index' }) }
      format.xml  { head :ok }
    end
  end


  def add_users
    @team = Team.find(params[:id])
    users = User.find_all_by_id(params[:user_ids])
    #puts @team
    #puts @team.sizes
    @team.users << users if request.post?
    respond_to do |format|
      format.html { redirect_to :controller => 'team', :action => 'edit', :id => @team, :tab => 'users' }
      format.js {
        render(:update) {|page|
          page.replace_html "tab-content-users", :partial => 'team/users'
          users.each {|user| page.visual_effect(:highlight, "user-#{user.id}") }
        }
      }
    end
  end

  def remove_user
    @team = Team.find(params[:id])
    @team.users.delete(User.find(params[:user_id])) if request.post?
    respond_to do |format|
      format.html { redirect_to :controller => 'team', :action => 'edit', :id => @team, :tab => 'users' }
      format.js { render(:update) {|page| page.replace_html "tab-content-users", :partial => 'team/users'} }
    end
  end

  def autocomplete_for_user
    @team = Team.find(params[:id])
    @users = User.active.like(params[:q]).find(:all, :limit => 100) - @team.users
    render :layout => false
  end
  
end
