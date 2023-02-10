class CreateTransactionService
  include Bitcoin::Builder

  def initialize(amount_get, recip_btc_address)
    @recip_btc_address = recip_btc_address
    @amount_get = amount_get
    @address = Setting.find_by(title: 'ex_wallet').value
    @net_fee = (Setting.find_by(title: 'net_fee').value.to_i / 0.00000001).round(0)
  end

  def call
    Bitcoin.network = :testnet3

    response = HTTParty.get("https://blockstream.info/testnet/api/address/#{@address}/txs", format: :plain)

    prev_out_index = 0
    prev_tx = response.first
    key_base58 = Wallet.find_by(address:).key
    key = Bitcoin::Key.from_base58(key_base58)

    # create a new transaction (and sign the inputs)
    new_tx = build_tx do |t|
      # add the input you picked out earlier
      t.input do |i|
        i.prev_out prev_tx
        i.prev_out_index prev_out_index
        i.signature_key key
      end

      # add an output that sends some bitcoins to another address
      t.output do |o|
        o.value 757 # 0,00000757 BTC in satoshis
        o.script { |s| s.recipient 'mjnYVFy5x9gwDH2Q12TNy7CP3v8zrtJboB' }
      end

      # add another output spending the remaining amount back to yourself
      # if you want to pay a tx fee, reduce the value of this output accordingly
      # if you want to keep your financial history private, use a different address
      t.output do |o|
        o.value 13_400 # 0,00013400 BTC, leave 0.00000600 BTC as fee
        o.script { |s| s.recipient key.addr }
      end
    end

    # examine your transaction. you can relay it through http://test.webbtc.com/relay_tx
    # that will also give you a hint on the error if something goes wrong
    puts new_tx.to_json
  end
end
