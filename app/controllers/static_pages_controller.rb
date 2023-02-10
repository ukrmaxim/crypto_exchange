class StaticPagesController < ApplicationController
  def index
    render locals: { ex_rate: Setting.find_by(title: 'ex_rate')&.value || 'Parameter not set',
                     ex_fee: Setting.find_by(title: 'ex_fee')&.value || 'Parameter not set',
                     net_fee: Setting.find_by(title: 'net_fee')&.value || 'Parameter not set' }
  end

  def update_rate
    ExchangeRateService.new('USDT', 'BTC').call

    redirect_to root_path, notice: 'Exchange rate was successfully updated'
  end
end
