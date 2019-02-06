class RenameColumnWebsiteInJobs < ActiveRecord::Migration[5.1]
  def change
    rename_column :jobs, :website, :job_website
  end
end
