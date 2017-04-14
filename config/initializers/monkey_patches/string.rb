String.class_eval do

  REGEX_NULLISH = /^[_<({\['\"]?(null|nil)[_>)}\]'\"]?$/io
  REGEX_NUMERIC = /^\d+$/

  # returns true if the string is 'nullish'
  # i.e. of the type /XnullX/i or /XnilX/i
  # where X is a bracket or quote-mark or nothing
  # 
  # @example Check if nullish
  #   'null'.nullish?   => true
  #   '"null"'.nullish? => true
  #   '<null>'.nullish? => true
  #   '_null_'.nullish? => true
  #   'xnullx'.nullish? => false
  #
  # @return [ true, false ] True if nullish, else false
  def nullish?
    return (self =~ REGEX_NULLISH)==0
  end

  def numeric?
    return (self =~ REGEX_NUMERIC)==0
  end

end
