class Job < ApplicationRecord
  belongs_to :search
  belongs_to :firm
  belongs_to :website
  acts_as_votable

  include PgSearch
  pg_search_scope :global_search,
  against: [ :title, :salary, :company ],
  using: {
    tsearch: { prefix: true }
  }
end
