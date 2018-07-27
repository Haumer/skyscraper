class JobsController < ApplicationController
  def index

  end

  def show
    @job = Job.find(params[:id])
    @jobs = Job.all.order(:quality)
  end

  def favourite_jobs

  end
end
