class FirmsController < ApplicationController
  def index
    @firms = Firm.all.sort_by { |firm| firm.jobs.count }.reverse
    ExtractCompaniesJob.perform_later
  end

  def show
    @firm = Firm.find(params[:id])
    @jobs = Job.where(firm_id: @firm)
  end
end
