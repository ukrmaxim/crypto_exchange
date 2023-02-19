class StaticPagesController < ApplicationController
  def index; end

  def update_rate
    ExchangeRateService.new('USDT', 'BTC').call

    redirect_to root_path, notice: 'Exchange rate was successfully updated'
  end
end
