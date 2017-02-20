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

end
