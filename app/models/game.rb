class Game < ApplicationRecord
  belongs_to :user
  has_many :parties, dependent: :destroy
end
