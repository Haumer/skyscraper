class AddFormatedSalaryToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :salary_format, :boolean
  end
end
