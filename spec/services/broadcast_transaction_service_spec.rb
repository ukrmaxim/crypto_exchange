require 'rails_helper'
require 'support/transactions_spec_helper'

RSpec.describe BroadcastTransactionService do
  let(:broadcast_transaction) { 'test_broadcast_transaction' }
  let(:transaction) { create(:transaction, status: 0) }
  let(:broadcast_service) { described_class.new(broadcast_transaction, transaction) }

  before do
    settings
  end

  describe '#call' do
    context 'when broadcasting is successful' do
      before do
        allow(HTTParty).to receive(:post).and_return(double(code: 200, body: 'test_txid'))
        broadcast_service.call
      end

      it 'updates transaction status to 0' do
        expect(transaction.reload.status).to eq('success')
      end

      it 'updates transaction txid' do
        expect(transaction.reload.txid).to eq('test_txid')
      end

      it 'returns the updated transaction' do
        expect(broadcast_service.call).to eq(transaction)
      end
    end

    context 'when broadcasting fails' do
      before do
        allow(HTTParty).to receive(:post).and_return(double(code: 500, body: 'test_txid'))
        broadcast_service.call
      end

      it 'updates transaction status to 1' do
        expect(transaction.reload.status).to eq('fail')
      end

      it 'updates transaction txid' do
        expect(transaction.reload.txid).to eq('test_txid')
      end

      it 'returns the updated transaction' do
        expect(broadcast_service.call).to eq(transaction)
      end
    end
  end
end
