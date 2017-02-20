class InvalidCardError < RuntimeError

  def initialize(number)
    super "#{Card.beautify_number number} is not a valid number"
  end

end