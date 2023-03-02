class WalletsController < ApplicationController
  before_action :set_wallet, only: %i[update destroy]
  http_basic_authenticate_with name: Rails.application.credentials.dig(:http_auth, :name),
                               password: Rails.application.credentials.dig(:http_auth, :password)

  rescue_from StandardError, with: :not_valid_base58_string

  def index
    @wallets = Wallet.all
    @new_wallet = Wallet.new
  end

  def create
    @wallet = GenerateWalletService.new(params).call

    if @wallet.save
      redirect_to wallets_path, notice: "Wallet '#{@wallet.title}' was successfully created."
    else
      redirect_to wallets_path, alert: @wallet.alert_errors
    end
  end

  def update
    if @wallet.update(wallet_params)
      redirect_to wallets_path, notice: "Wallet '#{@wallet.title}' was successfully updated."
    else
      redirect_to wallets_path, alert: @wallet.alert_errors
    end
  end

  def destroy
    @wallet.destroy
    redirect_to wallets_url, notice: 'Wallet was successfully destroyed.'
  end

  def check_balance
    CheckBalanceService.new.call

    redirect_to wallets_path, notice: 'Wallet balances was successfully updated'
  end

  private

  def set_wallet
    @wallet = Wallet.find(params[:id])
  end

  def wallet_params
    params.require(:wallet).permit(:title, :key)
  end

  def not_valid_base58_string
    redirect_to wallets_path, alert: 'Key not a valid Base58 string'
  end
end
