module TransactionsHelper
  def total_tx(transactions)
    transactions.count
  end

  def total_ex_fee(transactions)
    transactions.success.sum(&:ex_fee)
  end

  def total_success_tx(transactions)
    transactions.success.count
  end
end
