class SearchController < ApplicationController
  unloadable

  def search

    @starttime = params[:search][:create_at_start]
    @endtime = params[:search][:create_at_end]
    @starttime = Date.parse(@starttime)
    @endtime = Date.parse(@endtime)
    if @starttime !=nil and  @endtime != nil and @starttime.to_date < @endtime.to_date
      @userdailes = Userdaily.find(:all,:conditions => ["created_at >= ? and created_at <= ?", @starttime, @endtime])
      redirect_to({ :controller => 'report', :action => 'userindex' })
    else if @starttime ==nil and @starttime.to_date < @endtime.to_date
        @userdailes = Userdaily.find(:all,:conditions => ["created_at <= ?", @endtime])
        redirect_to({ :controller => 'report', :action => 'userindex' })
      else if @endtime ==nil and @starttime.to_date < @endtime.to_date
          @endtime = Date.today.to_s
          @userdailes = Userdaily.find(:all,:conditions => ["created_at >= ? and created_at <= ?", @starttime, @endtime])
          redirect_to({ :controller => 'report', :action => 'userindex' })
        else if @endtime ==nil and @endtime ==nil
            return nil
            redirect_to({ :controller => 'report', :action => 'userindex' })
          end
        end
      end
    end

  end
  
end
