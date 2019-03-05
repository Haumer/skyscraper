class AddMarketingToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :link_permission, :boolean, default: false
  end
end
