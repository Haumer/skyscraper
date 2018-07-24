class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :location
      t.string :website
      t.string :salary
      t.string :company
      t.string :link

      t.timestamps
    end
  end
end
