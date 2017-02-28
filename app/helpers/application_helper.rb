module ApplicationHelper

  class AppConfig

    def self.json
      JSON.parse ENV['APP_CONFIG']
    end

    def self.min_android_version
      json['android_version'].to_i
    end

    def self.android_version_valid?(client_version)
      eval(client_version.to_s).to_i >= min_android_version
    end

    def self.config_version
      json['config_version'].to_i
    end

    def self.config_version_valid?(config_version)
      eval(config_version.to_s).to_i == self.config_version
    end

    def self.check_type_subtype_valid?(type, subtype)
      value = type_exist?(type)
      unless value
        return false
      end
      if subtype_exist?(value, subtype)
        type_enabled?(value)
      end
    end

    def self.type_exist?(type)
      type = json['categories'].find {|x| x['id'] == type}
      return type
    end

    def self.subtype_exist?(type, subtype)
      type['subcategories'].any?{|s| s['id']==subtype}
    end

    def self.type_enabled? type
      type['enabled'] == true
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

  class StaticRSAHelper

    attr_reader :key

    def initialize(path = Rails.root + 'keys/private.pem', passphrase = 'othello-69')
      @key = OpenSSL::PKey::RSA.new File.read(path), passphrase
      unless @key.private? && @key.public?
        raise RuntimeError.new 'RSA Key-Pair invalid'
      end
    end

    def encrypt(data)
      Base64.encode64(@key.private_encrypt(data))
    end

    def decrypt(data)
      @key.private_decrypt(Base64.decode64(data))
    end

    # NOT TO BE USED BY SERVER - FOR TESTING PURPOSES ONLY
    def public_encrypt(data)
      Base64.encode64(@key.public_encrypt(data))
    end

    # NOT TO BE USED BY SERVER - FOR TESTING PURPOSES ONLY
    def public_decrypt(data)
      @key.public_decrypt(Base64.decode64(data))
    end

  end

  class TripleDESHelper
    # http://timolshansky.com/2011/10/23/ruby-triple-des-encryption.html

    def initialize(secret, algo = 'DES-EDE3-CBC')
      @secret = secret
      @algo = algo
    end

    def decrypt(data)
      cipher = OpenSSL::Cipher::Cipher.new(@algo)
      cipher.decrypt

      cipher.pkcs5_keyivgen(@secret)

      output = cipher.update(Base64.decode64(data))
      output << cipher.final
      output
    end

    def encrypt(data)
      cipher = OpenSSL::Cipher::Cipher.new(@algo)
      cipher.encrypt

      cipher.pkcs5_keyivgen(@secret)

      output = cipher.update(data)
      output << cipher.final
      Base64.encode64(output)
    end

  end

end
