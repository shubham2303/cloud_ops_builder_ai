class Agent < ApplicationRecord

  has_one :token, dependent: :delete
  has_many :collections

  validates_inclusion_of :state, :in => JSON.parse(ENV["APP_CONFIG"])['states'], :allow_blank => true
  validates_inclusion_of :lga, :in => JSON.parse(ENV["APP_CONFIG"])['lga'], :allow_blank => true

  validates_numericality_of :phone
  validates :phone, :lga, presence: true
  before_save :update_phone

  def update_phone
    if self.phone.length <=11
      self.phone= "234#{phone.last(10)}"
    end
  end

  def name
    (first_name.nil? ? '' : first_name) + ' ' + (last_name.nil? ? '' : last_name)
  end  
end