class WebsitesController < ApplicationController
  def index
    @websites = Website.all
  end

  def show
    @website = Website.find(params[:id])
    @jobs = @website.jobs.order(quality: :desc)
  end
end
