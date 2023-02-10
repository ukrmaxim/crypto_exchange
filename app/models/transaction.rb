class Transaction < ApplicationRecord
  encrypts :recip_email, :recip_btc_address, :txid, deterministic: true

  enum status: { success: 0, fail: 1 }
  enum currency: { USDT: 0, BTC: 1 }

  validates :amount_send, :amount_get, :recip_email, :recip_btc_address, :kyc, presence: true
  validates :amount_send, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 30 }
  validates :amount_get, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 30 }
  validates :recip_email, format: { with: /\A[\w.-]+@[a-z\d]+\.[a-z]+\z/ }
  # validates :recip_address
  scope :success, -> { where(status: 0) }
end
