class AddRecruiterToFirm < ActiveRecord::Migration[5.1]
  def change
    add_column :firms, :recruiter, :boolean, null: false, default: false
  end
end
