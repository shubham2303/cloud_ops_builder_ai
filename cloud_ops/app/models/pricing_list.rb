class PricingList
  include Mongoid::Document

  field :format_version, type: String
  field :disclaimer, type: String
  field :offer_code, type: String
  field :version, type: String
  field :publication_date, type: String

  has_many :product_lists
  has_many :terms

end