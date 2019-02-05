class Job < ApplicationRecord
  belongs_to :search
  belongs_to :firm
  acts_as_votable
end
