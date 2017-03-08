class Collection < ApplicationRecord

  belongs_to :batch
  belongs_to :agent
  belongs_to :business
  belongs_to :individual

  validates :category_type, :subtype, :number, :amount, :lga, presence: true
  validates_inclusion_of :lga, :in => JSON.parse(ENV["APP_CONFIG"])['lga'], :allow_nil => true
end