class AgentNotFound < StandardError

  def initialize(object = nil)
    if object.nil?
      @message = I18n.t(:agent_not_found)
    else
      @message = object
    end

  end

  def to_s
    @message
  end
end
