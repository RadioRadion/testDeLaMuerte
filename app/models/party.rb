class Party < ApplicationRecord
  belongs_to :game
  has_many :solutions
end
