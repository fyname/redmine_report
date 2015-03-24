class ReplyController < ApplicationController
  unloadable


  def show
    @reply = Reply.find(params[:id])
  end

  def new
    @reply = Reply.new
    session[:sub_id] =params[:id]
    puts "#########################################"
    puts session[:sub_id]
    puts "#########################################"
  end

  def create
    @dayOfWeek = [ "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" ]
    @t = Time.new
    @date =@t.strftime("%Y年%m月%d日 ") << @dayOfWeek[@t.strftime("%w").to_i]<< @t.strftime(" %H:%M %p")
    puts "###########################################"
    puts @date.to_s
    puts "###########################################"
    @reply = Reply.create(
      :user_id=>User.current.id,
      :user_name=>User.current.to_s,
      :userdaily_id=>session[:sub_id],
      :u_replycontent=>params[:reply][:u_replycontent],
      :u_replytime=>@date.to_s)
    session[:sub_id] =nil
    if @reply.save
      flash[:notice] = "回复成功！"
      redirect_to({ :controller => 'report', :action => 'userindex' })
    else
      flash[:notice] = "回复失败！"
      redirect_to({ :controller => 'report', :action => 'userindex' })
    end
  end

  def list

  end

  def edit
  end


  def update
  end

end
