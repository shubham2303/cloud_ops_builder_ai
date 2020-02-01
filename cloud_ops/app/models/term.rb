class Term
  include Mongoid::Document

  field :typ, type: String
  field :term_uid, type: String
  field :offer_term_code, type: String
  field :sku, type: String
  field :effective_date, type: String
  field :term_attributes, type: String

  embeds_one :price_dimension

  belongs_to :pricing_list
end