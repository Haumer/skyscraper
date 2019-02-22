class SingleRemoveDuplicatesJob < ApplicationJob
  queue_as :default

  def perform(id)
    sum = 0
    counter = 0
    @jobs = Job.all.where(search_id: id)
    @jobs.each do |job|
      # p job.title
      # p job.company
      # p job.search_id
      @duplicates = Job.all.where(title: job.title).where(company: job.company).where(salary: job.salary).where(search_id: job.search_id)
      if @duplicates.count > 1
        # puts `clear`
        sum -= 1
        sum += @duplicates.count
        counter += 1
      else
        # puts `clear`
        sum
        counter += 1
      end

      @duplicates[(1..-1)].each do |dup|
        dup.destroy
      end
    end
  end
end
