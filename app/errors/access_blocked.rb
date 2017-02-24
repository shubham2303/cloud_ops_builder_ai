class AccessBlocked < StandardError

def initialize(object = nil)
    @message = if object.is_a?(String)
                 object
               elsif object.is_a?(Token)
                 I18n.t(:outdated_token)
               else
                 nil
               end
    @default_message = @message
  end

  def to_s
    @message || @default_message
  end
end 