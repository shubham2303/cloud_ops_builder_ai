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
      vehicle = Vehicle.find_by!(vehicle_number: params[:vehicle_number].upcase)
      collections = vehicle.collections.where(agent: theAgent)
    else
      collections = theAgent.collections
    end
    with_pagination_and_order(collections, params[:page])
  end

  def self.with_pagination_and_order(collections, page)
    collections.order("created_at desc").page(page).per(10)
  end

  def self.generate_uuid(agent_id, created_at=nil)
    time=  created_at || Time.now.utc
    year = time.strftime("%Y")[2..4]
    year+time.strftime("%m%d%H%M%S")+agent_id.to_s
  end

  SELECT_CLAUSE_FOR_STAT_GENERATION = %{#{Collection.table_name}.*,
    #{Agent.table_name}.id AS agent_id,
    #{Agent.table_name}.first_name AS agent_fname,
    #{Agent.table_name}.last_name AS agent_lname,
    #{Agent.table_name}.address AS agent_address,
    #{Agent.table_name}.phone AS agent_phone,
    #{Agent.table_name}.created_at AS agent_cat,
    #{Agent.table_name}.beat_code AS agent_beat,
    #{Individual.table_name}.uuid AS payer_id,
    #{Individual.table_name}.first_name AS payer_fname,
    #{Individual.table_name}.last_name AS payer_lname,
    #{Individual.table_name}.address AS payer_address,
    #{Individual.table_name}.phone AS payer_phone,
    #{Individual.table_name}.amount AS payer_tot_amount,
    #{Individual.table_name}.created_at AS payer_cat}.gsub(/\s+/, ' ').strip
  def self.fetch_for_stats(start_date, end_date, offset)
    sx = start_date.to_date.beginning_of_day + offset.minutes
    ex = end_date.to_date.end_of_day + offset.minutes
    Collection.
        select(SELECT_CLAUSE_FOR_STAT_GENERATION).
        left_outer_joins(:agent).
        left_outer_joins(:individual).
        where("collections.created_at >= ? AND collections.created_at <= ?", sx, ex).
        includes(:collectionable)
  end

end