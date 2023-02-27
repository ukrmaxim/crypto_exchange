class StaticPagesController < ApplicationController
  def index; end

  def update_rate
    ExchangeRateService.new('USDT', 'BTC').call

    render turbo_stream: turbo_stream.replace('ex_rate', partial: 'ex_rate')
  end
end
