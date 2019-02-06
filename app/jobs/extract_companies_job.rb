class ExtractCompaniesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Job.all.each do |job|
      if job.company.downcase.include?(" ltd") || job.company.downcase.include?(" ltd.")
        job.company = job.company.downcase.strip.chomp(" ltd").chomp(" ltd.")
        p job.company
        job.save
      end
      if job.company.last == " "
        job.company = job.company[0..-2].capitalize
        job.save
      end
      if Firm.where(firm_name: job.company).count == 0
        p job.company
        @firm = Firm.create!(firm_name: job.company)
        job.firm_id = @firm.id
        job.save
        @firm.save
      else
        p job.company
        @firm = Firm.where(firm_name: job.company).first
        job.firm_id = @firm.id
        job.save
        @firm.save
      end
    end
  end
end
