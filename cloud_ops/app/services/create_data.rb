class CreateData

  def initialize(response)
    @response = response
    @pricing_list = create_pricing_list

  end

  def execute
    ProductList.collection.insert_many(get_products)
    Term.collection.insert_many(get_terms)
  end

  private

  def create_pricing_list
    hsh= {format_version: @response['formatVersion'],
          disclaimer: @response['disclaimer'],
          offer_code: @response['offerCode'],
          publication_date: @response['publicationDate'],
          version: @response['version']}
    @pricing_list = PricingList.create(hsh)
  end

  def get_products
    products = @response["products"]
    products_ops = []
    products.values.each do |value|
      product = {}
      product[:sku]= value['sku']
      product[:product_family] = value['productFamily']
      product[:pricing_list_id] = @pricing_list.id
      product_fields = {}
      attributes = value["attributes"]
      product_fields[:service_code] = attributes['servicecode']
      product_fields[:location] = attributes['location']
      product_fields[:location_type] = attributes['locationType']
      product_fields[:usage_type] = attributes['usagetype']
      product_fields[:operation] = attributes['operation']
      product_fields[:request_description] = attributes['requestDescription']
      product_fields[:request_type] = attributes['requestType']
      product_fields[:service_name] = attributes['servicename']
      product[:product_field] = product_fields
      products_ops << product
    end
    products_ops
  end

  def get_terms
    term_ops = []
    terms = @response["terms"]
    typ = terms.keys
    term_data = terms.values[0]
    terms_hsh = {}
    term_data.map do |key, data|
      data = data.values[0]
      terms_hsh[:type] = typ
      terms_hsh[:offer_term_code] = data['offerTermCode']
      terms_hsh[:sku] = data['sku']
      terms_hsh[:effective_date] = data['effectiveDate']
      terms_hsh[:term_attributes] = data['termAttributes']
      price_dimensions = {}
      p_d = data['priceDimensions'].values[0]
      terms_hsh[:pricing_list_id] = @pricing_list.id
      price_dimensions[:rate_code] = p_d['rateCode']
      price_dimensions[:description] = p_d['description']
      price_dimensions[:begin_range] = p_d['beginRange']
      price_dimensions[:end_range] = p_d['endRange']
      price_dimensions[:unit] = p_d['unit']
      price_dimensions[:price_per_unit] = p_d['pricePerUnit']
      price_dimensions[:applies_to] = p_d['appliesTo']
      terms_hsh[:price_dimension] = price_dimensions
      term_ops << terms_hsh
    end
  end
end