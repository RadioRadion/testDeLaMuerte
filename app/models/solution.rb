class Solution < ApplicationRecord
  belongs_to :party

  validates :word, presence: true
end
