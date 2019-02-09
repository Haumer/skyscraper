class AddUserAndSearchToSearchHistory < ActiveRecord::Migration[5.1]
  def change
    add_reference :search_histories, :user, index: true
    add_reference :search_histories, :search, index: true
  end
end
