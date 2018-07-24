class AddSearchToJobs < ActiveRecord::Migration[5.1]
  def change
    add_reference :jobs, :search, foreign_key: true
  end
end
