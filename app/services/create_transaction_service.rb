# rubocop:disable Metrics/MethodLength
class CreateTransactionService
  include Bitcoin::Builder

  def initialize(amount_get, recip_btc_address)
    @recip_btc_address = recip_btc_address
    @amount_get = (amount_get.to_f / 0.00000001).round(0)
    @address = Setting.find_by(title: 'ex_wallet')&.value
    @net_fee = (Setting.find_by(title: 'net_fee')&.value.to_f / 0.00000001).round(0)
    @wallet_balance = (Wallet.find_by(address: @address)&.balance.to_f / 0.00000001).round(0)
  end

  def call
    Bitcoin.network = :testnet

    txs = HTTParty.get("https://blockstream.info/testnet/api/address/#{@address}/txs")
    prev_out_index = 0

    prev_tx_id = txs.first['txid']
    prev_tx_hex = HTTParty.get("https://blockstream.info/testnet/api/tx/#{prev_tx_id}/hex")

    prev_tx = Bitcoin::P::Tx.new(prev_tx_hex.htb)

    key_base58 = Wallet.find_by(address: @address)&.key
    key = Bitcoin::Key.from_base58(key_base58)

    # create a new transaction (and sign the inputs)
    new_tx = build_tx do |t|
      t.input do |i|
        i.prev_out prev_tx
        i.prev_out_index prev_out_index
        i.signature_key key
      end

      # add an output that sends some bitcoins to another address
      t.output do |o|
        o.value @amount_get # BTC in satoshis
        o.script { |s| s.recipient @recip_btc_address }
      end

      t.output do |o|
        o.value @wallet_balance - @amount_get - @net_fee # leave @net_fee in satoshi as fee
        o.script { |s| s.recipient key.addr }
      end
    end

    hex_tx = Digest::SHA256.hexdigest new_tx.binary_hash

    HTTParty.post('https://blockstream.info/testnet/api/tx', body: hex_tx)
  end
end
# rubocop:enable Metrics/MethodLength
