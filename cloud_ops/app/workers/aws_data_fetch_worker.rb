class AwsDataFetchWorker
  include Sidekiq::Worker
  sidekiq_options backtrace: true


  def perform
    url = "https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonCloudFront/current/index.json"
    response = CurlRequest.new(url).post
    body = JSON.parse(response.body)
    data = CreateData.new(body)
    data.execute
  end
end