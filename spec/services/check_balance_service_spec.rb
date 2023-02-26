require 'rails_helper'

RSpec.describe CheckBalanceService do
  let!(:wallet) { create(:wallet, address: 'tb1q7rs6hnn5e9g5l5pvuph2y5f5w67rf8wjpjz3sc') }

  before do
    allow(HTTParty).to receive(:get).and_return([{ 'value' => 1366 }, { 'value' => 1344 }])
  end

  it 'updates wallet balance' do
    described_class.new.call
    expect(wallet.reload.balance).to eq(0.00002710)
  end
end
