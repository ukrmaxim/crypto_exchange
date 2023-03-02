class Wallet < ApplicationRecord
  encrypts :key, :priv_key, :pub_key
  encrypts :address, :title, deterministic: true

  enum action: { generate: 'generate', import: 'import' }

  validates :title, :address, :key, :priv_key, :pub_key, presence: true
  validates :title, :address, uniqueness: true
end
