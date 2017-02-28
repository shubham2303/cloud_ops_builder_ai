class Collection < ApplicationRecord

  belongs_to :batch
  belongs_to :agent
  belongs_to :business
  belongs_to :individual

  validates :category_type, :subtype, :number, :amount, presence: true
end