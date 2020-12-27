class Search < ApplicationRecord
  belongs_to :user
  has_many :jobs, dependent: :destroy
  has_many :websites, through: :jobs
  has_many :search_histories

  include PgSearch
  pg_search_scope :global_search,
    associated_against: {
      jobs: [ :salary, :company ]
    },
    using: {
      tsearch: { prefix: true }
    }

  def average_salary(jobs)
    @salaries = jobs.select { |job| job.salary.tr(",£", "").strip.to_i != 0 && job.salary.tr("£,", "").strip.to_i > 20000 }.map {|j| j.salary.tr("£,", "").strip.to_i}
    @avg_salary = 0
    unless @salaries.empty?
      @avg_salary = @salaries.sum / @salaries.size
    end
    return @avg_salary
  end
end
