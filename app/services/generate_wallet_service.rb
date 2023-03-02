class GenerateWalletService
  def initialize(params)
    @key = params[:wallet][:key]
    @title = params[:wallet][:title]
  end

  def call
    Bitcoin.network = :testnet
    key = if @key.present?
            Bitcoin::Key.from_base58(@key)
          else
            Bitcoin::Key.generate
          end

    Wallet.new(title: @title, address: key.addr, key: key.to_base58, priv_key: key.priv, pub_key: key.pub)
  end
end
