class PreRunAllJob < ApplicationJob
  queue_as :default

  def perform
    puts "Starting ...."
    puts ""
    puts ""
    puts ""

    @search = Search.new
    @search.user = User.all.first
    @search.title = "ruby"
    @search.location = "london"
    if @search.save
      ScrapeJob.perform_later(@search.title, @search.id)
      @search.save
      puts "I scraped"
      while ScrapeJob.working? == true
        if ScrapeJob.working? == false
          id = @search.last.id
          puts "id is #{id}"
          location = @search.job.last.location
          SingleFormatSalaryJob.perform_later(id)
          puts "I formatted the Salary"
          SingleFormatTitleJob.perform_later(id)
          puts "I formatted the Title"
          UpdateQualityJob.perform_later(id, location)
          puts "I updated the quality"
        end
      end
    end
    # Do something later
  end
end
