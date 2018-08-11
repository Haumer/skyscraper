class FormatTitleJob < ApplicationJob
  queue_as :default

  def perform

    Job.all.each do |e|
      a = []
      e.title.split.map do |c|
         a << c.capitalize
      end
      e.title = a.join(" ")
      e.save
    end
  end
end
