class ExtractCompaniesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Job.all.each do |job|
      next if job.id == 18698
      if Firm.where(firm_name: job.company.capitalize).count == 0
        p job.title
        @firm = Firm.create!(firm_name: job.company.capitalize)
        job.firm_id = @firm.id
        job.save
        @firm.save
      else
        p job.title
        @firm = Firm.where(firm_name: job.company.capitalize).first
        job.firm_id = @firm.id
        job.save
        @firm.save
      end
    end
  end
end
