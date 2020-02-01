class ProductList
  include Mongoid::Document
  field :sku, type: String
  field :product_family, type: String

  embeds_one :product_field

  belongs_to :pricing_list
end