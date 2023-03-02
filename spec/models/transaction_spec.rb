require 'rails_helper'
require 'support/transactions_spec_helper'

RSpec.describe Transaction do
  describe 'validations' do
    let(:transaction) { build(:transaction) }

    before do
      settings
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
