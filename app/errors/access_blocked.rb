class AccessBlocked < StandardError

  def initialize(object = nil)
    @message = I18n.t(:outdated_token)
  end

  def to_s
    @message
  end
end 