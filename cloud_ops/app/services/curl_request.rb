class CurlRequest

  def initialize(uri)
    @uri = URI.parse(uri)
  end

  public

  def post
    Net::HTTP.get_response(@uri)
  end
end
