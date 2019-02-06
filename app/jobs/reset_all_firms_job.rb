class ResetAllFirmsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Job.all.each do |job|
      job.firm_id = 1
      job.save
    end

    Firm.all.each do |firm|
      firm.delete unless firm.id == 1
    end
  end
end
