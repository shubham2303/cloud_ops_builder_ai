require 'digest'

class Digester

  def self.generate_secret(length = 128)
    return SecureRandom.hex(length / 2)
  end

  def self.hash_luhn_number!(number)
    unless Luhn.valid?(number)
      raise Exception.new "Input number (#{number}) is not valid'"
    end

    sha = Digest::SHA512.new
    sha.base64digest number
  end

  def self.hash_number_with_secret!(number, secret)
    unless Luhn.valid?(number)
      raise Exception.new "Input number (#{number}) is not valid'"
    end

    unless secret_valid?(secret)
      raise Exception.new "Input secret (#{secret}) is not valid'"
    end

    n = number.to_i
    f = n & 0xf

    sha = Digest::SHA512.new
    sha.base64digest (number + secret)
  end

  private

  def self.secret_valid?(secret)
    return !secret.nil? && secret.length >= 128
  end

end