# rubocop:disable Metrics/MethodLength, Metrics/PerceivedComplexity
class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show]
  http_basic_authenticate_with name: Rails.application.credentials.dig(:http_auth, :name),
                               password: Rails.application.credentials.dig(:http_auth, :password),
                               except: %i[new create show]

  # GET /transactions
  def index
    @transactions = Transaction.all

    render locals: { transactions: @transactions.order(id: :asc),
                     total_tx: @transactions.count,
                     total_ex_fee: @transactions.success.sum(&:ex_fee),
                     total_success_tx: @transactions.success.count }
  end

  def show
    render locals: { net_fee: Setting.find_by(title: 'net_fee')&.value || 'Parameter not set' }
  end

  # GET /transactions/new
  def new
    render locals: locals(Transaction.new)
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.valid?
      service = CreateTransactionService.new(params[:transaction][:amount_get],
                                             params[:transaction][:recip_btc_address]).call
      if service.code == 200
        @transaction = Transaction.new(transaction_params.merge(status: 0, txid: service.body))
        if @transaction.save
          redirect_to transaction_path(@transaction), notice: 'Exchange was successful'
        else
          render json: ErrorSerializer.serialize(@transaction.errors), status: :unprocessable_entity
        end
      else
        @transaction = Transaction.new(transaction_params.merge(status: 1, txid: service.body))
        if @transaction.save
          redirect_to new_transaction_path, alert: 'Exchange was not successful', locals: locals(@transaction)
        else
          render json: ErrorSerializer.serialize(@transaction.errors), status: :unprocessable_entity
        end
      end
    else
      render json: ErrorSerializer.serialize(@transaction.errors), status: :unprocessable_entity
    end
  end

  private

  def locals(transaction)
    { transaction:,
      ex_rate: Setting.find_by(title: 'ex_rate')&.value || 'Parameter not set',
      ex_fee: Setting.find_by(title: 'ex_fee')&.value || 'Parameter not set',
      net_fee: Setting.find_by(title: 'net_fee')&.value || 'Parameter not set' }
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:recip_email, :amount_get, :amount_send, :currency_from,
                                        :currency_to, :recip_btc_address, :kyc, :ex_fee, :ex_rate, :net_fee)
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/PerceivedComplexity
