class ProductField
  include Mongoid::Document
  field :service_code, type: String
  field :location, type: String
  field :location_type, type: String
  field :usage_type, type: String
  field :operation, type: String
  field :request_description, type: String
  field :request_type, type: String
  field :service_name, type: String

  embedded_in :product_list

end