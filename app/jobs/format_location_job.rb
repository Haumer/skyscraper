class FormatLocationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Job.all.each do |e|
      e.location = e.location.gsub(/from/, "").strip
      e.location = e.location.gsub(/London London/, "London").strip
      p e.location
      e.save
    end
  end
end
