require "open-uri"

class PreRunAllJob < ApplicationJob
  queue_as :default

  def perform(title, id)
    puts "Starting ...."
    puts ""
    puts ""
    puts ""

    # @search = Search.new
    # @search.user_id = User.all.first
    # @search.title = "ruby"
    # @search.location = "london"
    # search_id = @search.id
    # search_term = @search.title
    # search_location = @search.location
    # @id = @search.id
    # @search.save
    search_id = id
    firm_id = 1
    @id = id
    search_term = title.downcase
    if search_term.strip.split.count > 1
      search_term = search_term.strip.split.join("%20")
    end
    search_location = "london"

    @indeed_counter = 0
    @cvlibrary_counter = 0
    @escape_the_city_counter = 0
    @reed_counter = 0
    @ziprecruiter_counter = 0
    @totaljobs_counter = 0
    @monster_counter = 0
    @jobsite_counter = 0
    @jobstoday_counter = 0
    @cwjobs_counter = 1
    pages = Admin.all.first.pages
    rescued = {
      cvlibrary: false,
      jobsite: false,
      escapethecity: false,
      jobstoday: false,
      indeed: false,
      totaljobs: false,
      reed: false,
      ziprecruiter: false,
    }

    pages.times do

      if rescued[:cvlibrary] == false
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
                job_website: website,
                salary: salary,
                company: company,
                link: link,
                search_id: search_id,
                firm_id: firm_id,
                website_id: Website.where(website_name: website).first.id
              )
            end
          end
          @cvlibrary_counter += 25
          p "cvlibrary"
        rescue
          p "cvlibrary out of pages"
          rescued[:cvlibrary] == true
        end
      end

      if rescued[:jobsite] == false
        begin
          if @jobsite_counter.zero?
            results = []
            page = Nokogiri::HTML(open("https://www.jobsite.co.uk/jobs/#{search_term}/in-#{search_location}?radius=20"))
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
                  job_website: website,
                  salary: salary,
                  company: company,
                  link: link,
                  search_id: search_id,
                  firm_id: firm_id,
                  website_id: Website.where(website_name: website).first.id
                )
              end
            end
            @jobsite_counter += 2
          else
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
                  job_website: website,
                  salary: salary,
                  company: company,
                  link: link,
                  search_id: search_id,
                  firm_id: firm_id,
                  website_id: Website.where(website_name: website).first.id
                )
              end
            end
          @jobsite_counter += 1
          end
          p "jobsite"
        rescue
          p "jobsite out of pages"
          rescued[:jobsite] == true
        end
      end

      if rescued[:escapethecity] == false
        begin
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
              job_website: website,
              salary: salary,
              company: company,
              link: link,
              search_id: search_id,
              firm_id: firm_id,
              website_id: Website.where(website_name: website).first.id
            )
          end
          p "escape the city"
        rescue
          p "escapethecity is out of pages"
          rescued[:escapethecity] == true
        end
      end

      if rescued[:jobstoday] == false
        begin
          @jobstoday_counter += 1
          results = []
          page = Nokogiri::HTML(open("https://www.jobstoday.co.uk/searchjobs/?LocationId=1500&keywords=#{search_term}&radiallocation=10&countrycode=GB&Page=#{@jobstoday_counter}&sort=Relevance"))
          page.search(".lister__item--networkjob").each do |result_card|
            if result_card.search("h3").text.strip.downcase.include?(search_term)
              title = result_card.search("h3").text.strip
              link = "www.jobstoday.co.uk" + result_card.search("a").first['href']
              location = result_card.search(".lister__meta-item--location").text.strip.gsub(/\s{1,}/, " ")
              company = result_card.search(".lister__meta-item--recruiter").text.strip
              salary = result_card.search(".lister__meta-item--salary").text.strip.split("£").join("£ ")
              website = "www.jobstoday.co.uk"
              Job.create(
                title: title,
                location: location,
                job_website: website,
                salary: salary,
                company: company,
                link: link,
                search_id: search_id,
                firm_id: firm_id,
                website_id: Website.where(website_name: website).first.id
              )
            end
          end
          p "jobstoday"
        rescue
          p "jobstoday is out of pages"
          rescued[:jobstoday] == true
        end
      end

      if rescued[:indeed] == false
        begin
          page = Nokogiri::HTML(open("https://www.indeed.co.uk/jobs?q=#{search_term}&l=#{search_location}&start=#{@indeed_counter}"))
          page.search(".result").each do |result_card|
            if result_card.search(".jobtitle").text.strip.downcase.include?(search_term) && result_card.search('.location').text.strip
              title = result_card.search(".jobtitle").text.strip
              link = "https://www.indeed.co.uk" + result_card.search("a").first['href']
              company = result_card.search('.company').text.strip
              location = result_card.search('.location').text.strip
              if result_card.search(".no-wrap").text.strip == ""
                salary = "-"
              else
                salary = result_card.search(".no-wrap").text.strip.split("£").join("£ ")
              end
              website = "www.indeed.co.uk"
              Job.create(
                title: title,
                location: location,
                job_website: website,
                salary: salary,
                company: company,
                link: link,
                search_id: search_id,
                firm_id: firm_id,
                website_id: Website.where(website_name: website).first.id
              )
            end
          end
          p "indeed"
          @indeed_counter += 10
        rescue
          p "indeed is out of pages"
          rescued[:indeed] == true
        end
      end

      if rescued[:totaljobs] == false
        begin
          @totaljobs_counter += 1
          page = Nokogiri::HTML(open("https://www.totaljobs.com/jobs/#{search_term}/in-#{search_location}?radius=10&s=header&page=#{@totaljobs_counter}"))
          page.search(".job").each do |result_card|
            if result_card.search("h2").text.strip.downcase.include?(search_term)
              title = result_card.search("h2").text.strip
              link = result_card.search("a").first['href']
              location = result_card.search(".location").text.strip.gsub(/\s{1,}/, " ").split("-").first.strip
              company = result_card.search(".company").text.strip
              salary = result_card.search(".salary").text.strip.split("£").join("£ ")
              website = "www.totaljobs.com"
              Job.create(
                title: title,
                location: location,
                job_website: website,
                salary: salary,
                company: company,
                link: link,
                search_id: search_id,
                firm_id: firm_id,
                website_id: Website.where(website_name: website).first.id
              )
            end
          end
          p "totaljobs"
        rescue
          p "totaljobs is out of pages"
          rescued[:indeed] == true
        end
      end

      if rescued[:reed] == false
        begin
          @reed_counter += 1
          page = Nokogiri::HTML(open("https://www.reed.co.uk/jobs/jobs-in-#{search_location}?keywords=#{search_term}&cached=True&pageno=#{@reed_counter}"))
            page.search(".job-result").each do |result_card|
            if result_card.search(".gtmJobTitleClickResponsive").text.strip.downcase.include?(search_term)
              title = result_card.search(".gtmJobTitleClickResponsive").text.strip
              link = "https://www.reed.co.uk" + result_card.search("a").first['href']
              location = result_card.search(".location").text.strip.gsub(/\s{1,}/, " ")
              company = result_card.search(".gtmJobListingPostedBy").text.strip
              salary = result_card.search(".salary").text.strip.split("£").join("£ ")
              website = "www.reed.co.uk"
              Job.create(
                title: title,
                location: location,
                job_website: website,
                salary: salary,
                company: company,
                link: link,
                search_id: search_id,
                firm_id: firm_id,
                website_id: Website.where(website_name: website).first.id
              )
            end
          end
          p "reed"
        rescue
          p "reed is out of pages"
          rescued[:reed] == true
        end
      end

      if rescued[:ziprecruiter] == false

        begin
          page = Nokogiri::HTML(open("https://www.ziprecruiter.com/candidate/search?search=#{search_term}&location=#{search_location}%2C+ENG&page=#{@ziprecruiter_counter}"))
          page.search(".job_content").each do |result_card|
            if result_card.search(".just_job_title").text.strip.downcase.include?(search_term) && result_card.search(".location").text.strip.gsub(/\s{1,}/, " ").downcase.include?(search_location)
              title = result_card.search(".just_job_title").text.strip
              link = result_card.search("a").first['href']
              location = result_card.search(".location").text.strip.gsub(/\s{1,}/, " ")
              company = result_card.search(".name").text.strip
              website = "www.ziprecruiter.co.uk"
              salary = "-"
              Job.create(
                title: title,
                location: location,
                job_website: website,
                salary: salary,
                company: company,
                link: link,
                search_id: search_id,
                firm_id: firm_id,
                website_id: Website.where(website_name: website).first.id
              )
            end
          end
          p "ziprecruiter"
          @ziprecruiter_counter += 1
        rescue
          p "ziprecruiter is out of pages"
          rescued[:ziprecruiter] == true
        end
      end

      if rescued[:cwjobs] == false
        begin
        rescue
          rescued[:cwjobs] == true
        end


        # if @cwjobs_counter == 1
        #   page = Nokogiri::HTML(open("https://www.cwjobs.co.uk/jobs/#{search_term}/in-#{search_location}?radius=10&s=header"))
        # else
        #   page = Nokogiri::HTML(open("https://www.cwjobs.co.uk/jobs/#{search_term}/in-#{search_location}?radius=10&s=header&page=#{@cwjobs_counter}"))
        # end
        # page.search(".job").each do |element|
        #   title = element.search(".job-title").text.strip.gsub(/\s{1,}/, " ")
        #   salary = element.search(".salary").text.strip.gsub(/\s{1,}/, " ").gsub(/UKP/, "£").gsub(/k /, "000 ").strip
        #   company = element.search(".company").text.strip
        #   location = element.search(".location").text.strip.gsub(/\s{1,}/, " ").strip
        #   website = "www.cwjobs.co.uk"
        #   link = element.search("a").first['href']
        #   Job.create(
        #     title: title,
        #     location: location,
        #     job_website: website,
        #     salary: salary,
        #     company: company,
        #     link: link,
        #     search_id: search_id,
        # website_id: Website.where(website_name: website).first.id
        #   )
        # end
        # @cwjobs_counter += 1
      end
    end

    puts "id is #{id}"
    SingleFormatSalaryJob.perform_later(@id)
    puts "I formatted the Salary"
    SingleFormatTitleJob.perform_later(@id)
    puts "I formatted the Title"
    sleep(3)
    UpdateQualityJob.perform_later(@id, search_location)
    puts "I updated the quality"
    SingleRemoveDuplicatesJob.perform_later(@id)
    puts "I have removed duplicates"

    # Do something later
    # @search.save
  end
end
