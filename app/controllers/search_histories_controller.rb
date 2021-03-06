class SearchHistoriesController < ApplicationController
  def index
    @search_histories = SearchHistory.where(user: current_user)
    @search_histories_ordered = @search_histories.order(created_at: :desc)
    @grouped_by_job = group_by_job
  end

  def group_by_job
    @search_history = SearchHistory.where(id: 1).first
    @search_history.search.jobs.group_by { |job| job.website }
  end
end
