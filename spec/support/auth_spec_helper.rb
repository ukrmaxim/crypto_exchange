module AuthSpecHelper
  def http_basic_auth
    name = Rails.application.credentials.dig(:http_auth, :name)
    password = Rails.application.credentials.dig(:http_auth, :password)
    request.headers['AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(name, password)
  end
end

RSpec.configure do |config|
  config.include AuthSpecHelper
end
