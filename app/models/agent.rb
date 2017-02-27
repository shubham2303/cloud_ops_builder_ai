class Agent < ApplicationRecord

  has_one :token
  has_many :collections

  validates_inclusion_of :state, :in => JSON.parse(ENV["APP_CONFIG"])['states'], :allow_nil => true
  validates_inclusion_of :lga, :in => JSON.parse(ENV["APP_CONFIG"])['lga'], :allow_nil => true
end