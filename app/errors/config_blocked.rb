  class ConfigBlocked < StandardError

    def initialize(object = nil)
      @message = if object.is_a?(String)
       object
     elsif object.is_a?(Token)
       I18n.t(:outdated_config)
     else
       nil
     end
     @default_message = @message || I18n.t(:outdated_config)
   end

   def to_s
    @message || @default_message
  end
end
