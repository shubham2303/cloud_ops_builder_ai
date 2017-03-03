class Agent < ApplicationRecord

  has_one :token, dependent: :destroy
  has_many :collections

  validates_inclusion_of :state, :in => JSON.parse(ENV["APP_CONFIG"])['states'], :allow_blank => true
  validates_inclusion_of :lga, :in => JSON.parse(ENV["APP_CONFIG"])['lga'], :allow_blank => true

  validates_numericality_of :phone
  validates :phone, presence: true
end