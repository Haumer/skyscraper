class AddColumnsToScrapers < ActiveRecord::Migration[5.1]
  def change
    add_column :scrapers, :job_title, :string
    add_column :scrapers, :link, :string
    add_column :scrapers, :location, :string
    add_column :scrapers, :salary, :string
  end
end
