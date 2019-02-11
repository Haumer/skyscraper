class JobsController < ApplicationController
  def index

  end

  def create
    @search_room = SearchRoom.find(params[:id])
    if Job.create!
      ActionCable.server.broadcast("search_room_#{@search_room.id}", {
        search: @search.to_json
      })
    end
  end

  def show
    @job = Job.find(params[:id])
    @jobs = Job.all.order(:quality)
    @similar_jobs = Job.order(quality: :desc)
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
    @jobs = Job.all.order(:cached_votes_score => :desc).where(cached_votes_up: 1)
  end


  private
  def log_job_saved_to_db
    @search = Search.find(params[:id])
    render @search
  end
end
