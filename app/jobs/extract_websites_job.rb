class ExtractWebsitesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Job.all.each do |job|
      if job.website_id.nil? || job.website_id == 1
        web = Website.where(website_name: job.job_website).first.id
        job.website_id = web
        job.save
      end
    end
  end
end
