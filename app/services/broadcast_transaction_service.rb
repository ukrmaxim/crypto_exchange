class BroadcastTransactionService
  API_URL = 'https://blockstream.info/testnet/api/'.freeze

  def initialize(broadcast_transaction, transaction)
    @broadcast_transaction = broadcast_transaction
    @transaction = transaction
  end

  def call
    # Broadcast new transaction to network
    response = HTTParty.post("#{API_URL}tx", body: @broadcast_transaction)

    if response.code == 200
      @transaction.update(status: 0, txid: response.body)
    else
      @transaction.update(status: 1, txid: response.body)
    end
    @transaction
  end
end
