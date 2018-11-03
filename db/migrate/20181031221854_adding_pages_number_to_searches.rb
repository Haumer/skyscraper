class AddingPagesNumberToSearches < ActiveRecord::Migration[5.1]
  def change
    add_column :searches, :pages, :integer, null: false, default: 3
  end
end
