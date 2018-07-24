class AddUsersToSearches < ActiveRecord::Migration[5.1]
  def change
    add_reference :searches, :user, index: true
  end
end
