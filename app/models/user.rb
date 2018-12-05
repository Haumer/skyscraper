class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_voter
  has_many :searches
  has_many :jobs, through: :searches
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
