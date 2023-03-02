# rubocop:disable Metrics/MethodLength
class CreateTransactionService
  include Bitcoin::Builder

  API_URL = 'https://blockstream.info/testnet/api/'.freeze

  def initialize(transaction)
    @transaction = transaction
    @recip_btc_address = transaction.recip_btc_address
    @amount_get = btc_to_satoshi(transaction.amount_get)
    @ex_btc_address = Setting.find_by(title: 'ex_wallet')&.value
    @net_fee = btc_to_satoshi(transaction.net_fee)
    @key_base58 = Wallet.find_by(address: @ex_btc_address)&.key
    @wallet_balance = btc_to_satoshi(Wallet.find_by(address: @ex_btc_address)&.balance)
  end

  def call
    Bitcoin.network = :testnet

    bitcoin_protocol_txs = bitcoin_protocol_tx_list(@ex_btc_address)

    key = Bitcoin::Key.from_base58(@key_base58)

    # Create a new transaction with inputs
    new_tx = build_tx do |tx|
      bitcoin_protocol_txs.each do |bpt|
        build_input(tx, bpt, prev_out_indexs(bpt), key)
      end

      # Add an output that sends @amount_get to @recip_btc_address
      tx.output do |o|
        o.value @amount_get # BTC in satoshis
        o.script { |s| s.recipient @recip_btc_address }
      end

      # Add an output that sends change after the exchange operation to @ex_btc_address
      tx.output do |o|
        o.value @wallet_balance - @amount_get - @net_fee # leave @net_fee in satoshi
        o.script { |s| s.recipient key.addr }
      end
    end

    new_tx.to_payload.bth
  end

  private

  # Returns Bitcoin::Protocol::Tx object list
  def bitcoin_protocol_tx_list(address)
    utxo_txs(address).map { |txid| raw_transaction_binary(txid) }
  end

  # Convert BTC to satoshi
  def btc_to_satoshi(btc)
    (btc.to_f / 0.00000001).round(0)
  end

  # Build transaction inputs
  def build_input(transaction, prev_tx, prev_tx_indexs, key)
    prev_tx_indexs.each do |prev_tx_index|
      transaction.input do |i|
        i.prev_out prev_tx
        i.prev_out_index prev_tx_index
        i.signature_key key
      end
    end
  end

  # Return array of output numbers where transaction has output with @ex_btc_address
  def prev_out_indexs(transaction)
    tx_out = transaction.to_hash(with_address: true)['out']
    tx_out.each_index.select { |i| tx_out[i]['address'] == @ex_btc_address }
  end

  # Build Bitcoin::Protocol::Tx object from the raw transaction as binary data
  def raw_transaction_binary(txid)
    Bitcoin::Protocol::Tx.new(HTTParty.get("#{API_URL}tx/#{txid}/raw").to_s)
  end

  # Get the transaction list of unspent transaction outputs associated with the address
  def utxo_txs(address)
    HTTParty.get("#{API_URL}address/#{address}/utxo").pluck('txid')
  end
end
# rubocop:enable Metrics/MethodLength
