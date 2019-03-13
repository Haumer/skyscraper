class AddSearchPermissionToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :search_permission, :boolean, default: true
    add_column :users, :search_quantity, :integer, default: 3
    add_column :users, :search_last, :date
  end
end
