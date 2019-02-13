

class SearchesController < ApplicationController
  respond_to :html, :json
  def index
    @searches = Search.where(user_id: current_user.id)
    @searches_ordered = @searches.order(created_at: :desc)
  end

  def show
    @search = Search.find(params[:id])

    @jobs = Job.where(search_id: @search.id).order(quality: :desc)
    # if Search.all.map { |e| e.title }.include?(@search.title)
    #   @old_search = Search.where(title: @search.title).last
    #   @jobs = Job.where(search_id: @old_search.id).order(quality: :desc)
    #   respond_to :html, :js
    # else
    #   @jobs = Job.where(search_id: @search.id).order(quality: :desc)
    #   respond_to :html, :js
    # end
  end

  def new
    @search = Search.new
  end

  def favourite
    if !current_user.liked @job
      @job.liked_by current_user
    elsif current_user.liked @job
      @job.unliked_by current_user
    end
  end

  def create
    if Search.all.map { |e| e.title }.include?(search_params[:title].strip) && (Search.where(title: search_params[:title].strip).last.created_at) > (DateTime.now - 180.minutes)
      @search = Search.where(title: search_params[:title].strip).last
      redirect_to search_path(@search)
      @search_history = SearchHistory.create(search_id: @search.id, user_id: current_user.id)
      @search_history.save
    else
      @search = Search.new(search_params)
      @search.user = current_user
      @search.pages = Admin.all.first.pages
      if @search.save
        PreRunAllJob.perform_later(@search.title, @search.id)
        sleep(0.5)
        redirect_to search_path(@search)
        @search_history = SearchHistory.create(search_id: @search.id, user_id: current_user.id)
        @search_history.save
      else
        render :new
      end
    end
  end

  def stats
    @firms = Firm.all
    @firms = @firms.map { |firm| firm.jobs.count }
  end

  def dashboard
    @array = []
    hash = {}
    @search_histories = SearchHistory.where(user_id: current_user.id)
    @search_histories_ordered = @search_histories.order(created_at: :desc)

    @searches = Search.all.where(user_id: current_user.id).order(created_at: :desc)
    @searches.each { |search| @array << search.title }
    @title_freq = @array.group_by(&:itself).map { |k, v| hash[k] = v.count }
    @total = hash.sort_by { |_k, v| v.to_i }.reverse
  end

  def common
    @ruby = Search.where(title: "ruby").last
    @javascript = Search.where(title: "javascript").last
    @developer = Search.where(title: "developer").last
    @rails = Search.where(title: "rails")
  end

  private

  def search_params
    params.require(:search).permit(:title)
  end
end
