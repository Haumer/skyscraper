class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_voter
  has_many :search
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
