require "nokogiri"
require "open-uri"
class ScrapersController < ApplicationController
  def index
    @scrapers = Scraper.all
    @searches = Search.all
  end

  def show
    @scraper = Scraper.find(params[:id])
    scrape!(@scraper.keyword)
  end

  def scrape!(keyword)
    search_location = "london"
    search_term = keyword
    @escape_the_city_counter = 1
    page = Nokogiri::HTML(open("https://jobs.escapethecity.org/jobs/search?cat=&d=&l=#{search_location}%2C+UK&lat=51.5073509&long=-0.12775829999998223&page=#{@escape_the_city_counter}&q=#{search_term}"))
    page.search(".jobList-intro").each do |result_card|
      title = result_card.search(".jobList-title").text.strip
      link = "https://jobs.escapethecity.org" + result_card.search("a").first['href']
      location = search_location
      company = link.split("-at-")[1].gsub(/-/, " ").capitalize
      salary = "-"
      website = "www.escapethecity.org"
      Search.create(
        title: title,
        location: location,
        source: website,
        salary: salary
      )
    end
    @searches = Search.all
  end

  def new
    @scraper = Scraper.new
  end

  def create
    @scraper = Scraper.new(scraper_params)
    @scraper.save
    scrape!(@scraper.keyword)
    redirect_to scraper_path(@scraper)
  end

  private

  def scraper_params
    params.require(:scraper).permit(:keyword)
  end
end
