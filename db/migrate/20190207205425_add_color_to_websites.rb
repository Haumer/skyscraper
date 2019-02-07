class AddColorToWebsites < ActiveRecord::Migration[5.1]
  def change
    add_column :websites, :website_color, :string, default: "#00BFFF"
  end
end
