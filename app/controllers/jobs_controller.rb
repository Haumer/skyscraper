class JobsController < ApplicationController
  def index

  end

  def show
    @job = Job.find(params[:id])
    @jobs = Job.all.order(:quality)
  end

  def upvote
    @job = Job.find(params[:id])
    @job.upvote_from current_user
    redirect_back fallback_location: root_path
  end

  def downvote
    @job = Job.find(params[:id])
    @job.downvote_from current_user
    redirect_back fallback_location: root_path
  end

  def favourite
    @jobs = Job.all.order(:cached_votes_score => :desc).where(cached_votes_total: 1)
  end
end
