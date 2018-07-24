class CreateSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :searches do |t|
      t.string :title
      t.string :salary
      t.string :location
      t.string :link
      t.string :source

      t.timestamps
    end
  end
end
