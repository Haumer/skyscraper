class AddWebsiteToJob < ActiveRecord::Migration[5.1]
  def change
    add_reference :jobs, :website, index: true
  end
end
