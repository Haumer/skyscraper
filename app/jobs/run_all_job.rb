class RunAllJob < ApplicationJob
  queue_as :default

  def perform(id, location)
    FormatSalaryJob.perform_later
    FormatTitleJob.perform_later
    UpdateQualityJob.perform_later(id, location)
  end
end
