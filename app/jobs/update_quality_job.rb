class UpdateQualityJob < ApplicationJob
  queue_as :default

  def perform(search_id, search_location)
    p search_location
    p Job.all.where(search_id: search_id)
    Job.all.where(search_id: search_id).each do |job|
      counter = 0
      job.title.length < 35 ? counter += 1 : counter
      job.location.length < 20 ? counter += 1 : counter
      job.salary.length < 20 ? counter += 1 : counter
      job.salary == "-" || job.salary == "" ? counter -= 2 : counter += 1
      job.salary.gsub(/\D/, "").length > 7 ? counter += 1 : counter -= 1
      job.location.downcase.include?(search_location) ? counter += 1 : counter
      job.quality = (counter)
      job.save
    end
  end
end
