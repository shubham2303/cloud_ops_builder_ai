class TokenExpired < StandardError

	def initialize(object = nil)
		@message = I18n.t(:token_expiration)
	end

	def to_s
		@message
	end
end
