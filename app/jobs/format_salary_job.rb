class FormatSalaryJob < ApplicationJob
  queue_as :default

  def perform
    Job.all.each do |job|
      p job.salary
      if job.salary.scan(/\d/).length == 10
        sa = job.salary.scan(/\d/)
        p sa
        sal = "£ " + sa[(0..1)].join + "," + sa[(2..4)].join + " - £ " + sa[(5..6)].join + "," + sa[(7..9)].join
        p sal
        job.salary = sal
        job.save
        job.salary_format = true
        job.save
      elsif job.salary.scan(/\d/).length == 6 && job.salary.include?("-")
        sa = job.salary.scan(/\d/)
        p sa
        sal = "£ " + sa[(0..2)].join + " - £ " + sa[(3..5)].join
        p sal
        job.salary = sal
        job.save
        job.salary_format = true
        job.save
      elsif job.salary.include?("per annum") || job.salary.include?("pa")
        sa = job.salary.gsub(/per annum/, "").gsub(/pa/, "").strip
        job.salary = sa
        job.save
        job.salary_format = true
        job.save
      end
    end
  end
end
