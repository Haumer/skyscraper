class Search < ApplicationRecord
  belongs_to :user
  has_many :job
  has_many :websites, through: :job
  has_many :search_histories
end
