class Search < ApplicationRecord
  belongs_to :user
  has_many :jobs, dependent: :destroy
  has_many :websites, through: :jobs
  has_many :search_histories

  # include PgSearch
  # pg_search_scope :global_search,
  #   against: [ :title],
  #   associated_against: {
  #     jobs: [ :salary, :company ]
  #   },
  #   using: {
  #     tsearch: { prefix: true }
  #   }
  # multisearchable against: [ :title ]
end
