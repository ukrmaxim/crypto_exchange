class Wallet < ApplicationRecord
  encrypts :key, :priv_key, :pub_key
  encrypts :address, :title, deterministic: true

  enum action: { generate: 'generate', import: 'import' }

  validates :title, :address, :key, :priv_key, :pub_key, presence: true
  validates :title, :address, uniqueness: true

  # private

  # def key_in_base58
  #   Bitcoin.network = :testnet

  #   return if Bitcoin.valid_address?(recip_btc_address)

  #   errors.add(:recip_btc_address, 'invalid for testnet network')
  # end
end
