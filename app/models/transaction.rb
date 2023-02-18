class Transaction < ApplicationRecord
  encrypts :recip_email, :recip_btc_address, :txid, deterministic: true

  enum status: { success: 0, fail: 1 }

  validates :amount_send, :amount_get, :recip_email, :recip_btc_address, :ex_fee, :ex_rate, :net_fee, presence: true
  validates :amount_send, numericality: { greater_than_or_equal_to: 0.1, less_than_or_equal_to: 30 }
  validates :recip_email, format: { with: /\A[\w.-]+@[a-z\d]+\.[a-z]+\z/ }
  validates :kyc, acceptance: true
  validate :check_balance
  validate :allowed_btc_amount
  validate :btc_address

  scope :success, -> { where(status: 0) }

  private

  def allowed_btc_amount
    return if amount_get.nil?

    ex_rate = Setting.find_by(title: 'ex_rate')&.value.to_f
    ex_fee = Setting.find_by(title: 'ex_fee')&.value.to_f / 100
    net_fee = Setting.find_by(title: 'net_fee')&.value.to_f
    max_amount_get = ((30 * ex_rate) - ((30 * ex_rate) * ex_fee) - net_fee).round(8)

    errors.add(:amount_get, "cannot be more #{max_amount_get}") if amount_get > max_amount_get
  end

  def btc_address
    Bitcoin.network = :testnet

    return if Bitcoin.valid_address?(recip_btc_address)

    errors.add(:recip_btc_address, 'invalid for testnet network')
  end

  def check_balance
    return if amount_get.nil?

    CheckBalanceService.new.call

    wallet_address = Setting.find_by(title: 'ex_wallet')&.value
    wallet_balance = Wallet.find_by(address: wallet_address)&.balance.to_f

    errors.add(:amount_get, "cannot be more #{wallet_balance}") if amount_get > wallet_balance
  end
end
