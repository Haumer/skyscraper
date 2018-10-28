class RunAllJob < ApplicationJob
  queue_as :default

  def perform(id, location)
    ScrapeJob.perform_now
    FormatSalaryJob.perform_later
    FormatTitleJob.perform_later
    UpdateQualityJob.perform_later(id, location)
  end
end
