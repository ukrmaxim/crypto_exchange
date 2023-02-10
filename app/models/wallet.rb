class Wallet < ApplicationRecord
  encrypts :key, :priv_key, :pub_key
  encrypts :address, :title, deterministic: true

  validates :title, :address, :key, :priv_key, :pub_key, presence: true
  validates :title, uniqueness: true
end
