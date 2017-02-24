class VersionBlocked < StandardError

	def initialize(object = nil)
		@message = I18n.t(:outdated_version)
	end

	def to_s
		@message
	end
end
