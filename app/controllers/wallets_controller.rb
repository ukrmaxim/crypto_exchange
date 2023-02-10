class WalletsController < ApplicationController
  before_action :set_wallet, only: %i[update destroy]
  http_basic_authenticate_with name: Rails.application.credentials.dig(:http_auth, :name),
                               password: Rails.application.credentials.dig(:http_auth, :password)

  # GET /wallets
  def index
    render locals: { wallets: Wallet.all.order(title: :asc), new_wallet: Wallet.new }
  end

  # POST /wallets
  def create
    @wallet = GenerateWalletService.new(params[:wallet][:title]).call

    if @wallet.save
      redirect_to wallets_path, notice: "Wallet '#{@wallet.title}' was successfully created."
    else
      redirect_to wallets_path, alert: @wallet.alert_errors
    end
  end

  # PATCH/PUT /wallets/1
  def update
    if @wallet.update(wallet_params)
      redirect_to wallets_path, notice: "Wallet '#{@wallet.title}' was successfully updated."
    else
      redirect_to wallets_path, alert: @wallet.alert_errors
    end
  end

  # DELETE /wallets/1
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
    params.require(:wallet).permit(:title)
  end
end
