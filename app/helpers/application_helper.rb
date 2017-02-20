module ApplicationHelper

  class AppConfig

    def self.json
      JSON.parse ENV['APP_CONFIG']
    end

    def self.min_android_version
      json['android_version'].to_i
    end

    def self.android_version_valid?(client_version)
      client_version.to_i >= min_android_version
    end

    def self.config_version
      json['config_version'].to_i
    end

    def self.config_version_valid?(config_version)
      config_version.to_i == self.config_version
    end

  end

  class DynamicRSAHelper

    attr_reader :key

    def initialize(key_pair = nil)
      @key = key_pair || RSA::KeyPair.generate(2048)
      unless @key.valid? && @key.private_key? && @key.public_key?
        raise RuntimeError.new 'RSA Key-Pair invalid'
      end
    end

    def encrypt(data)
      Base64.encode64(@key.encrypt(data))
    end

    def decrypt(data)
      @key.decrypt(Base64.decode64(data))
    end

    def self.from_hash(hash)
      self.from_data hash[:n], hash[:d], hash[:e]
    end

    def self.from_data(modulus, priv_exponent, pub_exponent)
      self.new RSA::KeyPair.new(RSA::Key.new(modulus, priv_exponent), RSA::Key.new(modulus, pub_exponent))
    end

    def self.from_keys(priv_key, pub_key)
      self.new RSA::KeyPair.new(priv_key, pub_key)
    end

  end

end
