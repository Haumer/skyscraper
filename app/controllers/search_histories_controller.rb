class SearchHistoriesController < ApplicationController
  def index
    @search_histories = SearchHistory.where(user_id: current_user.id)
    @search_histories_ordered = @search_histories.order(created_at: :desc)
  end
end
