class Individual < ApplicationRecord

  has_many :businesses
  has_many :collections

  before_create :update_uuid

  validates :first_name, :last_name, :phone, :lga, presence: true
  validates_numericality_of :phone
  validates_inclusion_of :lga, :in => JSON.parse(ENV["APP_CONFIG"])['lga'], :allow_nil => true

  scope :today_created, ->{ where("Date(created_at) = ?", Date.today) }
  scope :this_month_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_month, Date.today) }
  scope :this_year_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_year, Date.today) }

  def update_uuid
    charac = first_name[0..2]
    i = ('1' + "0"*(6-charac.length-1)).to_i
    j = ('9' + "9"*(6-charac.length-1)).to_i
    self.uuid =charac +rand(i..j).to_s
  end

  def name
    first_name + ' ' + last_name
   end  

end