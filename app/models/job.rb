class Job < ApplicationRecord
  belongs_to :search
  acts_as_votable
end
