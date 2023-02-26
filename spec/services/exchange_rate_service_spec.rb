require 'rails_helper'

RSpec.describe ExchangeRateService do
  describe '#call' do
    let(:currency_from) { 'USDT' }
    let(:currency_to) { 'BTC' }
    let(:fake_response_body) { '0.00004054' }

    before do
      allow(HTTParty).to receive(:get).and_return(double(body: fake_response_body))
    end

    context 'when the setting exists' do
      let!(:setting) { create(:setting, title: 'ex_rate', value: '0.00004050') }

      it 'updates the setting if the value differs from the response' do
        expect { described_class.new(currency_from, currency_to).call }.to change {
          setting.reload.value
        }.from('0.00004050').to(fake_response_body)
      end

      it 'does not update the setting if the value matches the response' do
        allow(HTTParty).to receive(:get).and_return(double(body: '0.00004050'))

        expect { described_class.new(currency_from, currency_to).call }.not_to change {
          setting.reload.value
        }
      end
    end

    context 'when the setting does not exist' do
      it 'creates a new setting' do
        expect { described_class.new(currency_from, currency_to).call }.to change {
          Setting.where(title: 'ex_rate').count
        }.from(0).to(1)

        setting = Setting.find_by(title: 'ex_rate')
        expect(setting.value).to eq(fake_response_body)
      end
    end
  end
end
