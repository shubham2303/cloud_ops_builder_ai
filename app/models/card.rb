class Card < ApplicationRecord

  belongs_to :batch

  validates :x, uniqueness: true

  def self.verify_and_use(number, amount)
    card = verify_and_get number

    if card.usage >= card.amount
      raise AmountExceededError.new "Card has been exhausted on #{card.updated_at.to_formatted_s(:short)}"
    end

    if card.usage + amount > card.amount
      raise AmountExceededError.new "#{amount} exceed the card's allowed amount of #{card.amount - card.usage}"
    end

    card.with_lock(true) do
      card.usage += amount
      card.save!
    end

    card
  end

  def self.beautify_number(number)
    return number if number.nil? || /\A\d+\z/.match(number.to_s).nil?
    str = number.to_s.reverse
    str = str.scan(/.{1,4}/).map { |x| x.reverse }
    str = str.reverse.join("-")
    return str
  end

  private

  def self.verify_and_get(number)
    raise InvalidCardError.new number unless Luhn.valid?(number)

    x = Digester.hash_luhn_number!(number.to_s)
    begin
      card = find_by! x: x
    rescue
      raise InvalidCardError.new number
    end

    y = card.y
    z = Digester.hash_number_with_secret!(number.to_s, y)
    if card.z == z
      return card
    else
      raise InvalidCardError.new number
    end
  end

end
