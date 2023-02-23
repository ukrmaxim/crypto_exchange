require 'rails_helper'

RSpec.describe Transaction do
  describe 'validations' do
    let(:transaction) { build(:transaction) }
    let(:setting1) { create(:setting, title: 'ex_rate', value: '0.00004054') }
    let(:setting2) { create(:setting, title: 'ex_fee', value: '0.00000061') }
    let(:setting3) { create(:setting, title: 'net_fee', value: '0.00000600') }
    let(:setting4) { create(:setting, title: 'ex_wallet', value: 'mg1eiohebTsKsmr2UyrzojYLpg6EMqYMLA') }
    let(:wallet) {
      create(:wallet, title: 'ex_wallet', address: 'mg1eiohebTsKsmr2UyrzojYLpg6EMqYMLA',
                      key: 'bc3fa53a7bc8cd7198c64b8bdd425cd0a', priv_key: 'bc3fa53a7bc8cd7198c64b8bdd425cd0a',
                      pub_key: 'bc3fa53a7bc8cd7198c64b8bdd425cd0a', balance: 0.01954054)
    }

    before do
      setting1
      setting2
      setting3
      setting4
      wallet
      transaction.validate
    end

    it 'is valid with valid attributes' do
      expect(transaction).to be_valid
    end

    it 'is not valid without amount_send' do
      transaction.amount_send = nil
      expect(transaction).not_to be_valid
    end

    it 'is not valid with amount_send less than 0.1' do
      transaction.amount_send = 0.05
      expect(transaction).not_to be_valid
    end

    it 'is not valid with amount_send more than 30' do
      transaction.amount_send = 31
      expect(transaction).not_to be_valid
    end

    it 'is not valid without amount_get' do
      transaction.amount_get = nil
      expect(transaction).not_to be_valid
    end

    it 'is not valid with amount_get more than max amount' do
      transaction.amount_get = 1.00000000
      expect(transaction).not_to be_valid
    end

    it 'is not valid without recip_email' do
      transaction.recip_email = nil
      expect(transaction).not_to be_valid
    end

    it 'is not valid with invalid recip_email format' do
      transaction.recip_email = 'invalid_email'
      expect(transaction).not_to be_valid
    end

    it 'is not valid without recip_btc_address' do
      transaction.recip_btc_address = nil
      expect(transaction).not_to be_valid
    end

    it 'is not valid with invalid btc address format' do
      transaction.recip_btc_address = 'invalid_address'
      expect(transaction).not_to be_valid
    end

    it 'is not valid without ex_fee' do
      transaction.ex_fee = nil
      expect(transaction).not_to be_valid
    end

    it 'is not valid without ex_rate' do
      transaction.ex_rate = nil
      expect(transaction).not_to be_valid
    end

    it 'is not valid without net_fee' do
      transaction.net_fee = nil
      expect(transaction).not_to be_valid
    end

    it 'is not valid without kyc acceptance' do
      transaction.kyc = false
      expect(transaction).not_to be_valid
    end
  end

  describe 'callbacks' do
    let(:transaction) { build(:transaction) }

    it 'calls CheckBalanceService after check_balance validation' do
      expect_any_instance_of(CheckBalanceService).to receive(:call)
      transaction.validate
    end
  end
end
