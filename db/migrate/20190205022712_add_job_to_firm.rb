class AddJobToFirm < ActiveRecord::Migration[5.1]
  def change
    add_reference :jobs, :firm, index: true
  end
end
