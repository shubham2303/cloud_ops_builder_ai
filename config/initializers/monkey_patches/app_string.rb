class AppString
	attr_reader :version, :config

	@@app_config = JSON.parse(ENV["APP_CONFIG"])

	def initialize(ver = nil, config = nil)
		@version = ver.to_i
		@config  = config
	end

	def is_valid_version?
		return false unless @version

		return false if @version <= 0

		if @version == @@app_config['android_version']
			return true
		else
			return false	
		end	
	end	

	def is_valid_config?
		if @config == @@app_config['config_version']
			return true
		else
			return false	
		end	
	end	

end	