class AddQualityToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :quality, :float
  end
end
