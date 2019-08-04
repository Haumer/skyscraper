class SearchesController < ApplicationController
  def show
    @search = Search.find(params[:id])
    if params[:filter].present?
      @jobs = Job.global_search(params[:filter]).where(search: @search)
      @salaries = @jobs.select { |job| job.salary.scan(/\d/).length > 7 }
      @avg_salary = 0
      unless @salaries.empty?
        @avg_salary = (@salaries.map { |e| e.salary.scan(/\d/)[0..4].join.to_i }.sum / @salaries.length).to_s
        @avg_salary = "#{@avg_salary[0..1]}.#{@avg_salary[2..4]}"
      end
    else
      @jobs = @search.jobs.order(quality: :desc)
      @salaries = @jobs.select { |job| job.salary.scan(/\d/).length > 7 }
      @avg_salary = 0
      unless @salaries.empty?
        @avg_salary = (@salaries.map { |e| e.salary.scan(/\d/)[0..4].join.to_i }.sum / @salaries.length).to_s
        @avg_salary = "#{@avg_salary[0..1]}.#{@avg_salary[2..4]}"
      end
      @links = @search.jobs.map { |job| job.link }.join(", ")
    end
  end

  def index
    @searches = Search.where(user_id: current_user.id)
    @searches_ordered = @searches.order(created_at: :desc)
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
    if (Search.all.map { |e| e.title }.include?(search_params[:title].strip) && (Search.where(title: search_params[:title].strip).last.created_at) > (DateTime.now - 180.minutes))
      @search = Search.where(title: search_params[:title].strip).last
      redirect_to search_path(@search)
      @search_history = SearchHistory.create(search_id: @search.id, user_id: current_user.id)
      @search_history.save
    else
      @search = Search.new(search_params)
      @search.user = current_user
      @search.pages = Admin.all.first.pages
      @search.location = ""
      if @search.save
        PreRunAllJob.perform_later(@search.title, @search.id)
        sleep(1.5)
        respond_to do |format|
          format.html { redirect_to search_path(@search) }
          format.js
        end
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
    @ruby = Search.where(title: "ruby")
    @javascript = Search.where(title: "javascript").last
    @developer = Search.where(title: "developer").last
    @rails = Search.where(title: "rails")
  end

  private

  def search_params
    params.require(:search).permit(:title)
  end
end
