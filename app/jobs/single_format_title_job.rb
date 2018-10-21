class SingleFormatTitleJob < ApplicationJob
  queue_as :default

  def perform(id)
    puts "starting the title formatting ..."
    Search.find(id).job.each do |e|
      puts "starting job with id #{e.id}"
      a = []
      e.title.split.map do |c|
         a << c.capitalize
      end
      e.title = a.join(" ")
      e.save
    end
    puts "done"
  end
end
