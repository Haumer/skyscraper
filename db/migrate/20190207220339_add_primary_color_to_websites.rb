class AddPrimaryColorToWebsites < ActiveRecord::Migration[5.1]
  def change
    add_column :websites, :primary_website_color, :string, default: "#00BFFF"
  end
end
