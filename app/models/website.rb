class Website < ApplicationRecord
  has_many :jobs
  has_many :searches, through: :jobs
end
