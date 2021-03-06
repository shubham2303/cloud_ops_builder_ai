class Individual < ApplicationRecord

  has_many :businesses, dependent: :delete_all
  has_many :vehicles, dependent: :delete_all
  has_many :collections

  before_validation :update_phone
  validates :first_name, :last_name, :phone, :lga, presence: true
  validates_numericality_of :phone
  validates :phone, uniqueness: true
  validates_inclusion_of :lga, :in => JSON.parse(ENV["APP_CONFIG"])['lga'], :allow_nil => true

  scope :today_created, ->{ where("Date(created_at) = ?", Date.today) }
  scope :this_month_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_month, Date.today) }
  scope :this_year_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_year, Date.today) }

  def update_uuid
    charac = first_name[0..2]
    i = ('1' + "0"*(6-charac.length-1)).to_i
    j = ('9' + "9"*(6-charac.length-1)).to_i
    self.uuid =(charac +rand(i..j).to_s).upcase
  end

  def self.generate_payer_id(first_name, last_name, id)
    time=  Time.now.utc
    year = time.strftime("%Y")[2..4]
    (first_name+last_name)[0..2].upcase+year+time.strftime("%m%d%H%M%S")+id.to_s
  end

  def self.generate_payer_id_v2(id)
    time=  Time.now.utc
    year = time.strftime("%Y")[2..4]
    ShortUUID.encode((year+time.strftime("%m%d%H%M%S")+id.to_s).to_i)
  end

  def self.check_lga_with_agent(agent, lga)
    agent.lga == lga
  end

  def self.verify_lga_with_agent_and_param(agent, lga, individual_lga)
    if self.check_lga_with_agent(agent, lga)
      agent.lga == individual_lga
    else
      false
    end
  end

  def self.verify_object_lga(param_lga, obj_lga)
    param_lga == obj_lga
  end

  def update_phone
    if self.phone.length <=11
      self.phone= ("234#{phone.last(10)}")
    end
  end

  def name
    first_name + ' ' + last_name
  end

  def self.get_accurate_number(n)
   "234"+n.last(10)
  end

end
