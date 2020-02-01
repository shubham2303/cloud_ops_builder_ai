class PricingSerializer < ActiveModel::Serializer
  attributes :description, :beginRange, :endRange, :unit, :pricePerUnit, :effectiveDate

  def description
    object.price_dimension[:description]
  end

  def beginRange
    object.price_dimension[:begin_range]
  end

  def endRange
    object.price_dimension[:end_range]
  end

  def unit
    object.price_dimension[:unit]
  end

  def pricePerUnit
    object.price_dimension[:price_per_unit]["USD"]
  end

  def effectiveDate
    object[:effective_date]
  end
end