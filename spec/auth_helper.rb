module AuthHelper

  def json
    JSON.parse ENV['APP_CONFIG']
  end  

  def reset_headers
    @request.env.delete 'HTTP_UID'
    @request.env.delete 'HTTP_TOKEN'
    @request.env.delete 'HTTP_ANDROID_VER'
    @request.env.delete 'HTTP_CONFIG_VER'
  end

  def set_headers(agent)
    reset_headers
    @request.env['HTTP_UID'] = agent.id
    @request.env['HTTP_TOKEN'] = agent.reload.token.token
    @request.env['HTTP_CONFIG_VER'] = json['config_version']
    @request.env['HTTP_ANDROID_VER'] = json['android_version']
  end

end

RSpec.configure do |config|
  config.include AuthHelper
end
