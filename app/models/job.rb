class Job < ApplicationRecord
  after_create :broadcast_job
  belongs_to :search
  belongs_to :firm
  belongs_to :website
  acts_as_votable
end
