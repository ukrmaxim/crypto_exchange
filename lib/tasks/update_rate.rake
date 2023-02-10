namespace :update do
  desc 'Update exchange rate'
  task rate: :environment do
    ExchangeRateService.new('USDT', 'BTC').call
  end
end
