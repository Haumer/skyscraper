class Job < ApplicationRecord
  belongs_to :search
  belongs_to :firm
  belongs_to :website
  acts_as_votable

  # include PgSearch
  # multisearchable against: [ :salary ]
end
