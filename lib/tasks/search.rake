namespace :search do
  desc "Search all websites for a job"
  task :all, [:job] => :environment do |t, args|
    jobs = [
      "ruby",
      "rails",
      "javascript",
      "python",
      "frontend developer",
      "backend developer",
      "fullstack developer",
      "data scientist",
      "data analyst",
      "software developer"
    ]
    puts "Scraping jobs"
    jobs.each do |job_title|
      search = Search.create(title: job_title)
      search.user = User.first
      search.pages = Admin.first.pages
      search.location = ""
      PreRunAllJob.perform_later(search.title, search.id)
    end
  end
end
