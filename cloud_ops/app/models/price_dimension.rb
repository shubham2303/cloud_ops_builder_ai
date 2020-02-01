class PriceDimension
  include Mongoid::Document

  field :rate_code, type: String
  field :description, type: String
  field :begin_range, type: String
  field :end_range, type: String
  field :unit, type: String
  field :price_per_unit, type: String
  field :applies_to, type: String

  embedded_in :term

end