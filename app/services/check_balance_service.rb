class CheckBalanceService
  def call
    Wallet.all.each do |wallet|
      address = wallet.address
      response = HTTParty.get("https://blockstream.info/testnet/api/address/#{address}/utxo")
      sum = (response.sum { |value| value['value'] } * 0.00000001).round(8)
      wallet.update!(balance: sum)
    end
  end
end
