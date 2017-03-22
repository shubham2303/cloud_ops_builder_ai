class Collection < ApplicationRecord

  belongs_to :batch
  belongs_to :agent
  belongs_to :collectionable, polymorphic: true
  belongs_to :individual

  scope :today_created, ->{ where("Date(created_at) = ?", Date.today) }
  scope :this_month_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_month, Date.today) }
  scope :this_year_created, ->{ where("Date(created_at) >= ? AND Date(created_at) <= ?",Date.today.at_beginning_of_year, Date.today) }

  validates :category_type, :subtype, :number, :amount, :lga, presence: true
  validates_inclusion_of :lga, :in => JSON.parse(ENV["APP_CONFIG"])['lga'], :allow_nil => true

  def self.get_collections(params, theAgent)
    if params[:uuid]
      individual = Individual.find_by!(uuid: params[:uuid].upcase)
      collections = individual.collections.where(agent: theAgent)
    elsif params[:phone_number]
      number = Individual.get_accurate_number(params[:phone_number])
      individual = Individual.find_by!(phone: number)
      collections = individual.collections.where(agent: theAgent)
    elsif params[:vehicle_number]
      vehicle = Vehicle.find_by!(vehicle_number: params[:vehicle_number])
      collections = vehicle.collections.where(agent: theAgent)
    else
      collections = theAgent.collections
    end
    with_pagination_and_order(collections, params[:page])
  end

  def self.with_pagination_and_order(collections, page)
    collections.order("created_at desc").paginate(:page => page, :per_page => 10)
  end
end