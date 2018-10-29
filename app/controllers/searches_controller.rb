require 'Nokogiri'
require 'open-uri'

class SearchesController < ApplicationController
  def index
    @searches = Search.where(user_id: current_user.id)
    @searches_ordered = @searches.order(created_at: :desc)
  end

  def show
    @search = Search.find(params[:id])
    @jobs = Job.where(search_id: @search.id).order(quality: :desc)
    respond_to :html, :js
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
    @search = Search.new(search_params)
    @search.user = current_user
    if @search.save
      @search.save
      PreRunAllJob.perform_later(@search.title, @search.id)
      # ScrapeJob.perform_later(@search.title, @search.id)
      redirect_to search_path(@search)
    else
      render :new
    end
  end

  def stats
    @jobs = Job.all
    array = []
    Job.all.each { |e| array << e.company.strip }
    @companys = array.uniq.sort
    @recru = @companys.select { |e| e.include?("rec") || e.include?("Rec")}
    @company_freq = array.group_by(&:itself).map { |k, v| "#{v.count}-#{k}" }
  end

  def dashboard
    @array = []
    @searches = Search.all.where(user_id: current_user.id).order(created_at: :desc)
    @searches.each { |search| @array <<search.title }
    @title_freq = @array.group_by(&:itself).map { |k, v| "#{v.count}-#{k}" }.sort.reverse
    @total = @title_freq.map { |element|element.split("-").first.to_i }
  end

  private

  def search_params
    params.require(:search).permit(:title)
  end
end
