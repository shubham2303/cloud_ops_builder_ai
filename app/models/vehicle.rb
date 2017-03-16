class Vehicle < ApplicationRecord

  belongs_to :individual
  has_many :collections, :as => :collectionable

  # validates_inclusion_of :lga, :in => JSON.parse(ENV["APP_CONFIG"])['lga'], :allow_nil => true


end