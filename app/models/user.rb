class User < ApplicationRecord
  has_many :chores, dependent: :destroy

  validates :name, presence: true

  validates :email, presence: true
  validates :email, uniqueness: true
end
