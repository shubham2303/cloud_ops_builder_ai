class Individual < ApplicationRecord

  has_many :businesses
  has_many :collections

  before_create :update_uuid

  validates :first_name, :last_name, :phone, :lga, presence: true
  validates_numericality_of :phone
  validates_inclusion_of :lga, :in => JSON.parse(ENV["APP_CONFIG"])['lga'], :allow_nil => true

  def update_uuid
    charac = first_name[0..2]
    i = ('1' + "0"*(6-charac.length-1)).to_i
    j = ('9' + "9"*(6-charac.length-1)).to_i
    self.uuid =charac +rand(i..j).to_s
  end
end