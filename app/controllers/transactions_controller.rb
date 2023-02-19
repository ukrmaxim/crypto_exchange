class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show]
  http_basic_authenticate_with name: Rails.application.credentials.dig(:http_auth, :name),
                               password: Rails.application.credentials.dig(:http_auth, :password),
                               except: %i[new create show]

  def index
    @pagy, @transactions = pagy(Transaction.all.order(created_at: :desc))
  end

  def show; end

  def new
    @transaction = Transaction.new
  end

  def create
    @new_transaction = Transaction.new(transaction_params)

    if @new_transaction.valid?
      broadcast_transaction = CreateTransactionService.new(@new_transaction).call
      @transaction = BroadcastTransactionService.new(broadcast_transaction, @new_transaction).call

      redirect_to transaction_path(@transaction)
    else
      render json: ErrorSerializer.serialize(@new_transaction.errors), status: :unprocessable_entity
    end
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:recip_email, :amount_get, :amount_send, :currency_from,
                                        :currency_to, :recip_btc_address, :kyc, :ex_fee, :ex_rate, :net_fee)
  end
end
