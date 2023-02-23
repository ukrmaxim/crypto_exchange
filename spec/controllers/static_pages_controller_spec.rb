require 'rails_helper'

RSpec.describe StaticPagesController do
  describe 'PATCH #update_rate' do
    let(:exchange_rate_service) { instance_double(ExchangeRateService) }

    before do
      allow(ExchangeRateService).to receive(:new).and_return(exchange_rate_service)
      allow(exchange_rate_service).to receive(:call)
    end

    it 'calls ExchangeRateService with correct arguments' do
      expect(ExchangeRateService).to receive(:new).with('USDT', 'BTC').and_return(exchange_rate_service)
      patch :update_rate
    end

    it 'redirects to the root page' do
      patch :update_rate
      expect(response).to redirect_to(root_path)
    end

    it 'sets a flash notice message' do
      patch :update_rate
      expect(flash[:notice]).to eq('Exchange rate was successfully updated')
    end
  end
end
