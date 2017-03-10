class Business < ApplicationRecord

  belongs_to :individual
  has_many :collections, :as => :collectionable

  validates_inclusion_of :lga, :in => JSON.parse(ENV["APP_CONFIG"])['lga'], :allow_nil => true
  validates :name, :address, :lga, :year, presence: true

  scope :today_created, ->{ where("Date(created_at) = ?", Date.today) }
  scope :this_month_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_month, Date.today) }
  scope :this_year_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_year, Date.today) }
end