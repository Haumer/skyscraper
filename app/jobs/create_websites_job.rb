class CreateWebsitesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    websites = ["www.cv-library.co.uk",
      "www.jobsite.com",
      "www.escapethecity.org",
      "www.jobstoday.co.uk",
      "www.indeed.co.uk",
      "www.totaljobs.com",
      "www.reed.co.uk",
      "www.ziprecruiter.co.uk",
      "www.cwjobs.co.uk"]
    websites.each do |website|
      Website.create(website_name: website)
    end

    Job.all.each do |job|
      if job.website_id.nil?
        web = Website.where(website_name: job.job_website).first.id
        job.website_id = web
        job.save
      end
    end
  end
end
