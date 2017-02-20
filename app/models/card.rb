class Card < ApplicationRecord

  belongs_to :batch

  validates :x, uniqueness: true

end
