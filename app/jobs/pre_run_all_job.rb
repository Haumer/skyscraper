require "open-uri"

class PreRunAllJob < ApplicationJob
  queue_as :default

  def perform(title, id)
    puts "Starting ...."
    puts ""
    puts ""
    puts ""

    search_id = id
    firm_id = 1
    @id = id
    search_term = title.downcase.strip
    original_search_term = search_term
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
    pages = Admin.first.pages
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
          url = "https://www.cv-library.co.uk/search-jobs?distance=15&fp=1&geo=#{search_location}&offset=#{@cvlibrary_counter}&posted=28&q=#{search_term}&salarymax=&salarymin=&salarytype=annum&search=1&tempperm=Any"
          page = Nokogiri::HTML(open(url))
          page.search(".job-search-description").each do |result_card|
            if result_card.search("#js-jobtitle-details").text.strip.downcase.include?(original_search_term)
              p title = result_card.search("#js-jobtitle-details").text.strip.gsub(/\u00a0/, '')
              link = "https://www.cv-library.co.uk" + result_card.search(".jobtitle-divider a").first['href']
              location = result_card.search("#js-loc-details").text.strip.gsub(/\n/, "").split.join(" ")
              company = result_card.search(".agency-link-mobile").text.strip.gsub(/\u00a0/, '').downcase
              if result_card.search("#js-salary-details").text.strip.gsub(/Â/, "").split("/").first.nil? || result_card.search("#js-salary-details").text.strip.gsub(/Â/, "").split("/").first == ""
                salary = "-"
              else
                salary = result_card.search("#js-salary-details").text.strip.gsub(/Â/, "").split("/").first.split("£").join("£ ").gsub(/\u00a0/, '')
              end
              website = "www.cv-library.co.uk"
              Job.create!(
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
            p url = "https://www.jobsite.co.uk/jobs/#{search_term}/in-#{search_location}?radius=20"
            page = Nokogiri::HTML(open(url))
            page.search(".job").each do |result_card|
              if result_card.search("h2").text.strip.downcase.include?(original_search_term)
                title = result_card.search("h2").text.strip.gsub(/\u00a0/, '')
                link = result_card.search("a").first['href']
                location = result_card.search(".location").text.strip.gsub(/\s{1,}/, " ").split("-").first.strip
                company = result_card.search(".company").text.strip.gsub(/\u00a0/, '').downcase
                salary = result_card.search(".salary").text.strip.split("£").join("£ ").gsub(/\u00a0/, '')
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
            p url = "https://www.jobsite.co.uk/jobs/#{search_term}/in-#{search_location}?radius=10&page=#{@jobsite_counter}"
            page = Nokogiri::HTML(open(url))
            page.search(".job").each do |result_card|
              if result_card.search("h2").text.strip.downcase.include?(original_search_term)
                title = result_card.search("h2").text.strip.gsub(/\u00a0/, '')
                link = result_card.search("a").first['href']
                location = result_card.search(".location").text.strip.gsub(/\s{1,}/, " ").split("-").first.strip
                company = result_card.search(".company").text.strip.gsub(/\u00a0/, '').downcase
                salary = result_card.search(".salary").text.strip.split("£").join("£ ").gsub(/\u00a0/, '')
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
          p url = "https://jobs.escapethecity.org/jobs/search?cat=&d=&l=#{search_location}%2C+UK&lat=51.5073509&long=-0.12775829999998223&page=#{@escape_the_city_counter}&q=#{search_term}"
          @escape_the_city_counter += 1
          page = Nokogiri::HTML(open(url))
          page.search(".jobList-intro").each do |result_card|
            if result_card.search(".jobList-title").text.strip.downcase.include?(original_search_term)
              title = result_card.search(".jobList-title").text.strip.gsub(/\u00a0/, '')
              link = "https://jobs.escapethecity.org" + result_card.search("a").first['href']
              location = search_location
              company = link.split("-at-")[1].gsub(/-/, " ").gsub(/\u00a0/, '').downcase
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
          p url = "https://www.jobstoday.co.uk/searchjobs/?LocationId=1500&keywords=#{search_term}&radiallocation=10&countrycode=GB&Page=#{@jobstoday_counter}&sort=Relevance"
          page = Nokogiri::HTML(open(url))
          page.search(".lister__item--networkjob").each do |result_card|
            if result_card.search("h3").text.strip.downcase.include?(original_search_term)
              title = result_card.search("h3").text.strip.gsub(/\u00a0/, '')
              link = "www.jobstoday.co.uk" + result_card.search("a").first['href']
              location = result_card.search(".lister__meta-item--location").text.strip.gsub(/\s{1,}/, " ")
              company = result_card.search(".lister__meta-item--recruiter").text.strip.gsub(/\u00a0/, '').downcase
              salary = result_card.search(".lister__meta-item--salary").text.strip.split("£").join("£ ").gsub(/\u00a0/, '')
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
          p url = "https://www.indeed.co.uk/jobs?q=#{search_term}&l=#{search_location}&start=#{@indeed_counter}"
          page = Nokogiri::HTML(open(url))
          page.search(".result").each do |result_card|
            if result_card.search(".jobtitle").text.strip.downcase.include?(original_search_term) && result_card.search('.location').text.strip
              title = result_card.search(".jobtitle").text.strip.gsub(/\u00a0/, '')
              link = "https://www.indeed.co.uk" + result_card.search("a").first['href']
              location = result_card.search('.location').text.strip.gsub(/\u00a0/, '')
              company = result_card.search('.company').text.strip.gsub(/\u00a0/, '').downcase
              if result_card.search(".no-wrap").text.strip == ""
                salary = "-"
              else
                salary = result_card.search(".no-wrap").text.strip.split("£").join("£ ").gsub(/\u00a0/, '')
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
          p url = "https://www.totaljobs.com/jobs/#{search_term}/in-#{search_location}?radius=10&s=header&page=#{@totaljobs_counter}"
          page = Nokogiri::HTML(open(url))
          page.search(".job").each do |result_card|
            if result_card.search("h2").text.strip.downcase.include?(original_search_term)
              title = result_card.search("h2").text.strip.gsub(/\u00a0/, '')
              link = result_card.search("a").first['href']
              location = result_card.search(".location").text.strip.gsub(/\s{1,}/, " ").split("-").first.strip
              company = result_card.search(".company").text.strip.gsub(/\u00a0/, '').downcase
              salary = result_card.search(".salary").text.strip.split("£").join("£ ").gsub(/\u00a0/, '')
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
          p url = "https://www.reed.co.uk/jobs/jobs-in-#{search_location}?keywords=#{search_term}&cached=True&pageno=#{@reed_counter}"
          page = Nokogiri::HTML(open(url))
          page.search(".job-result").each do |result_card|
            if result_card.search(".gtmJobTitleClickResponsive").text.strip.downcase.include?(original_search_term)
              title = result_card.search(".gtmJobTitleClickResponsive").text.strip.gsub(/\u00a0/, '')
              link = "https://www.reed.co.uk" + result_card.search("a").first['href']
              location = result_card.search(".location").text.strip.gsub(/\s{1,}/, " ")
              company = result_card.search(".gtmJobListingPostedBy").text.strip.gsub(/\u00a0/, '').downcase
              salary = result_card.search(".salary").text.strip.split("£").join("£ ").gsub(/\u00a0/, '')
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
          p url = "https://www.ziprecruiter.com/candidate/search?search=#{search_term}&location=#{search_location}%2C+ENG&page=#{@ziprecruiter_counter}"
          page = Nokogiri::HTML(open(url))
          page.search(".job_content").each do |result_card|
            if result_card.search(".just_job_title").text.strip.downcase.include?(original_search_term) && result_card.search(".location").text.strip.gsub(/\s{1,}/, " ").downcase.include?(search_location)
              title = result_card.search(".just_job_title").text.strip.gsub(/\u00a0/, '')
              link = result_card.search("a").first['href']
              location = result_card.search(".location").text.strip.gsub(/\s{1,}/, " ")
              company = result_card.search(".name").text.strip.gsub(/\u00a0/, '').downcase
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


        if @cwjobs_counter == 1
          p url = "https://www.cwjobs.co.uk/jobs/#{search_term}/in-#{search_location}?radius=10&s=header"
          page = Nokogiri::HTML(open(url))
        else
          url = "https://www.cwjobs.co.uk/jobs/#{search_term}/in-#{search_location}?radius=10&s=header&page=#{@cwjobs_counter}"
          page = Nokogiri::HTML(open(url))
        end
        page.search(".job").each do |element|
          title = element.search(".job-title").text.strip.gsub(/\s{1,}/, " ").gsub(/\u00a0/, '')
          salary = element.search(".salary").text.strip.gsub(/\s{1,}/, " ").gsub(/UKP/, "£").gsub(/k /, "000 ").strip.gsub(/\u00a0/, '')
          location = element.search(".location").text.strip.gsub(/\s{1,}/, " ").strip.gsub(/\u00a0/, '')
          company = element.search(".company").text.strip.gsub(/\u00a0/, '').downcase
          website = "www.cwjobs.co.uk"
          link = element.search("a").first['href']
          Job.create(
            title: title,
            location: location,
            job_website: website,
            salary: salary,
            company: company,
            link: link,
            firm_id: firm_id,
            search_id: search_id,
            website_id: Website.where(website_name: website).first.id
          )
        end
        @cwjobs_counter += 1
        end
      end
    end

    puts "id is #{id}"
    SingleFormatSalaryJob.perform_later(@id)
    puts "I formatted the Salary"
    SingleFormatTitleJob.perform_later(@id)
    puts "I formatted the Title"
    UpdateQualityJob.perform_later(@id, search_location)
    puts "I updated the quality"
    SingleRemoveDuplicatesJob.perform_later(@id)
    puts "I have removed duplicates"
    ExtractCompaniesJob.perform_later
    puts "I have extracted Firms"

    # Do something later
    search = Search.where(id: search_id).first
    search.job_done = true
    search.save
  end
end
