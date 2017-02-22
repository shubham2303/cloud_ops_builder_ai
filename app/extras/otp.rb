class Otp

	def self.make
		if Rails.env.production?
			rand(0000..9999).to_s.rjust(4, "0")
		else
			'1111'
		end
	end

end