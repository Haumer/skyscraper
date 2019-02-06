class WebsitesController < ApplicationController
  def index
    @websites = Website.all
  end
end
