class Agent < ApplicationRecord

  has_one :token, dependent: :delete
  has_many :collections

  validates_inclusion_of :state, :in => ApplicationHelper::AppConfig.json['states'], :allow_blank => true
  validates_inclusion_of :lga, :in => ApplicationHelper::AppConfig.json['lga'], :allow_blank => false
  validates_inclusion_of :beat_code, :in => ->(agent) {ApplicationHelper::AppConfig.beat_json[agent.lga].keys }, :allow_blank => false
  validates_numericality_of :phone
  validates :phone, uniqueness: true
  validates :phone, :lga, :beat_code, presence: true
  before_validation :update_phone

  def update_phone
    if self.phone.length <=11
      self.phone= "234#{phone.last(10)}"
    end
  end

  def name
    (first_name.nil? ? '' : first_name) + ' ' + (last_name.nil? ? '' : last_name)
  end

  def revenue_beat
    ApplicationHelper::AppConfig.beat_json[lga][beat_code]
  end
end