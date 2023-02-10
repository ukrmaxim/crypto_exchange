class GenerateWalletService
  def initialize(title)
    @title = title
  end

  def call
    Bitcoin.network = :testnet3
    key = Bitcoin::Key.generate

    Wallet.new(title: @title, address: key.addr, key: key.to_base58, priv_key: key.priv, pub_key: key.pub)
  end
end
