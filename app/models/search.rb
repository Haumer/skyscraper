class Search < ApplicationRecord
  belongs_to :user
  has_many :jobs
  has_many :websites, through: :jobs
  has_many :search_histories
end
