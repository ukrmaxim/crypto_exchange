require 'rails_helper'
require 'bitcoin'

RSpec.describe GenerateWalletService do
  describe '#call' do
    let(:title) { 'Test wallet' }
    let(:service) { described_class.new(title) }
    let(:wallet) { service.call }
    let(:priv_key) { Bitcoin::Key.from_base58(wallet.key).priv }
    let(:pub_key) { Bitcoin::Key.from_base58(wallet.key).pub }

    it 'returns a Wallet object' do
      expect(wallet).to be_a(Wallet)
    end

    it 'sets the title attribute' do
      expect(wallet.title).to eq(title)
    end

    it 'generates a valid Bitcoin address' do
      expect(Bitcoin.valid_address?(wallet.address)).to be(true)
    end

    it 'generates a valid private key' do
      expect(Bitcoin::Key.from_base58(wallet.key).priv).to eq(priv_key)
    end

    it 'generates a valid public key' do
      expect(Bitcoin::Key.from_base58(wallet.key).pub).to eq(pub_key)
    end
  end
end
