require 'rails_helper'
require 'support/transactions_spec_helper'

RSpec.describe CreateTransactionService, type: :service do
  describe '#call' do
    let(:transaction) { create(:transaction, status: 0) }

    before do
      settings
    end

    it 'returns valid hex transaction for broadcast' do
      service = described_class.new(transaction)
      expect(service.call).to be_a(String)
    end
  end
end
