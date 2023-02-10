class TransactionsController < ApplicationController
  http_basic_authenticate_with name: Rails.application.credentials.dig(:http_auth, :name),
                               password: Rails.application.credentials.dig(:http_auth, :password),
                               except: %i[new create]

  # GET /transactions
  def index
    @transactions = Transaction.all

    render locals: { transactions: @transactions,
                     total_tx: @transactions.count,
                     total_ex_fee: @transactions.sum(&:ex_fee),
                     total_success_tx: @transactions.success.count }
  end

  # GET /transactions/new
  def new
    render locals: locals(Transaction.new)
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      redirect_to @transaction, notice: 'Transaction was successfully created.'
    else
      redirect_to new_transaction_path, alert: @transaction.alert_errors, locals: locals(@transaction)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def transaction_params
    params.require(:transaction).permit(:recip_email, :amount_get, :amount_send, :currency_from,
                                        :currency_to, :recip_btc_address, :kyc)
  end

  def locals(transaction)
    { transaction:,
      ex_rate: Setting.find_by(title: 'ex_rate')&.value || 'Parameter not set',
      ex_fee: Setting.find_by(title: 'ex_fee')&.value || 'Parameter not set',
      net_fee: Setting.find_by(title: 'net_fee')&.value || 'Parameter not set' }
  end
end
