class Job < ApplicationRecord
  belongs_to :search, touch: true
  acts_as_votable
end
