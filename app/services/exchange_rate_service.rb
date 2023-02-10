class ExchangeRateService
  def initialize(currency_from, currency_to)
    @currency_from = currency_from
    @currency_to = currency_to
  end

  def call
    response = HTTParty.get("https://api.coingate.com/api/v2/rates/merchant/#{@currency_from}/#{@currency_to}")

    setting = Setting.find_by(title: 'ex_rate')
    if setting.present?
      return if setting.value == response.body

      setting.update!(value: response.body)
    else
      Setting.create(title: 'ex_rate', value: response.body, description: 'Exchange rate (in BTC)')
    end
  end
end
