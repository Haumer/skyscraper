class JobsController < ApplicationController
  def index

  end

  def show
    @job = Job.find(params[:id])
    @jobs = Job.all
  end
end
