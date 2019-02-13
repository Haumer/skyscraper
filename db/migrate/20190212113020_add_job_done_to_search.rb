class AddJobDoneToSearch < ActiveRecord::Migration[5.1]
  def change
    add_column :searches, :job_done, :boolean, default: false
  end
end
