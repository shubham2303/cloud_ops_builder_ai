class AgentNotFound < StandardError

  def initialize(object = nil)
    @message = I18n.t(:agent_not_found)
  end

  def to_s
    @message
  end
end
