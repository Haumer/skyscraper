require 'Nokogiri'
require 'open-uri'

class SearchesController < ApplicationController
  def index
    @searches = Search.where(user_id: current_user.id)
    # @jobs = Jobs.where(id: search_id)
  end

  def show
    @search = Search.find(params[:id])
    @jobs = Job.where(search_id: @search.id).order(quality: :desc)
    # UpdateQualityJob.perform_later(@search.id, @search.location)
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

  def scrape!(keyword, search_id)
    search_location = "london"
    search_term = keyword.downcase
    @escape_the_city_counter = 0
    @cvlibrary_counter = 0
    @jobsite_counter = 0
    pages = 10

    pages.times do
      begin
        page = Nokogiri::HTML(open("https://www.cv-library.co.uk/search-jobs?distance=15&fp=1&geo=#{search_location}&offset=#{@cvlibrary_counter}&posted=28&q=#{search_term}&salarymax=&salarymin=&salarytype=annum&search=1&tempperm=Any"))
        page.search(".job-search-description").each do |result_card|
          if result_card.search("#js-jobtitle-details").text.strip.downcase.include?(search_term)
            title = result_card.search("#js-jobtitle-details").text.strip
            link = "https://www.cv-library.co.uk" + result_card.search(".jobtitle-divider a").first['href']
            location = result_card.search("#js-loc-details").text.strip.gsub(/\n/, "").split.join(" ")
            company = result_card.search(".agency-link-mobile").text.strip
            if result_card.search("#js-salary-details").text.strip.gsub(/Â/, "").split("/").first.nil? || result_card.search("#js-salary-details").text.strip.gsub(/Â/, "").split("/").first == ""
              salary = "-"
            else
              salary = result_card.search("#js-salary-details").text.strip.gsub(/Â/, "").split("/").first.split("£").join("£ ")
            end
            website = "www.cv-library.co.uk"
            Job.create(
              title: title,
              location: location,
              website: website,
              salary: salary,
              company: company,
              link: link,
              search_id: search_id
            )
          end
        end
        @cvlibrary_counter += 25
      rescue
      end

      @jobsite_counter += 1
      results = []
      page = Nokogiri::HTML(open("https://www.jobsite.co.uk/jobs/#{search_term}/in-#{search_location}?radius=10&page=#{@jobsite_counter}"))
      page.search(".job").each do |result_card|
        if result_card.search("h2").text.strip.downcase.include?(search_term)
          title = result_card.search("h2").text.strip
          link = result_card.search("a").first['href']
          location = result_card.search(".location").text.strip.gsub(/\s{1,}/, " ").split("-").first.strip
          company = result_card.search(".company").text.strip
          salary = result_card.search(".salary").text.strip.split("£").join("£ ")
          website = "www.jobsite.com"
          Job.create(
            title: title,
            location: location,
            website: website,
            salary: salary,
            company: company,
            link: link,
            search_id: search_id
          )
        end
      end

      @escape_the_city_counter += 1
      page = Nokogiri::HTML(open("https://jobs.escapethecity.org/jobs/search?cat=&d=&l=#{search_location}%2C+UK&lat=51.5073509&long=-0.12775829999998223&page=#{@escape_the_city_counter}&q=#{search_term}"))
      page.search(".jobList-intro").each do |result_card|
        title = result_card.search(".jobList-title").text.strip
        link = "https://jobs.escapethecity.org" + result_card.search("a").first['href']
        location = search_location
        company = link.split("-at-")[1].gsub(/-/, " ").capitalize
        salary = "-"
        website = "www.escapethecity.org"
        Job.create(
          title: title,
          location: location,
          website: website,
          salary: salary,
          company: company,
          link: link,
          search_id: search_id
        )
      end
    end
  end

  def create
    @search = Search.new(search_params)
    @search.user = current_user
    if @search.save
      ScrapeJob.perform_later(@search.title, @search.id)
      # scrape!(@search.title, @search.id)
      redirect_to search_path(@search)
      # UpdateQualityJob.perform_later(@search.id)
    else
      render :new
    end
  end

  private

  def search_params
    params.require(:search).permit(:title)
  end
end
