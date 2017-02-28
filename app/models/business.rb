class Business < ApplicationRecord

  belongs_to :individual
  has_many :collections

  validates_inclusion_of :lga, :in => JSON.parse(ENV["APP_CONFIG"])['lga'], :allow_nil => true
  validates :address, :category, :lga, :year, presence: true

  before_create :update_guid

  def update_guid
    self.uuid = 'B-'+ShortUUID.unique
  end

end