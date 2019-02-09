class CreateSearchHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :search_histories do |t|

      t.timestamps
    end
  end
end
