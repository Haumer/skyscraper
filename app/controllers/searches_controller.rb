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
    @search.pages = Admin.all.first.pages
    @search.save
    p "this search id is: #{@search.id}"
    if @search.save
      PreRunAllJob.perform_later(@search.title, @search.id)
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
    @recru = @companys.select { |e| e.include?("rec") || e.include?("Rec") }

    # count the number of mentions of company and sort
    hash = {}
    array.group_by(&:itself).map { |k, v| hash[k] = v.count }
    @company_freq = hash.sort_by { |_k, v| v.to_i }.reverse

    # count number of mentions of website and sort
    hash = {}
    web = Job.all.map { |e| e.website.strip unless e.website.nil? }
    web2 = web.group_by(&:itself).map { |k, v| hash[k] = v.count }
    @websites = hash.sort_by { |_k, v| v.to_i }
  end

  def dashboard
    @array = []
    hash = {}
    @searches = Search.all.where(user_id: current_user.id).order(created_at: :desc)
    @searches.each { |search| @array << search.title }
    @title_freq = @array.group_by(&:itself).map { |k, v| hash[k] = v.count }
    @total = hash.sort_by { |_k, v| v.to_i }.reverse
  end

  private

  def search_params
    params.require(:search).permit(:title)
  end
end
