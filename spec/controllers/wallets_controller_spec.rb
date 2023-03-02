require 'rails_helper'
require 'support/auth_spec_helper'

RSpec.describe WalletsController do
  describe 'GET #index' do
    let(:wallet1) { create(:wallet) }
    let(:wallet2) { create(:wallet) }

    it 'requires authentication' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it 'assigns all wallets to @wallets' do
      http_basic_auth
      get :index
      expect(assigns(:wallets)).to eq([wallet1, wallet2])
    end

    it 'assigns a new Wallet to new_wallet' do
      http_basic_auth
      get :index
      expect(assigns(:new_wallet)).to be_a_new(Wallet)
    end
  end

  describe 'POST #create' do
    let(:generate_wallet_service) { instance_double(GenerateWalletService) }

    before do
      http_basic_auth
      allow(GenerateWalletService).to receive(:new).and_return(generate_wallet_service)
      allow(generate_wallet_service).to receive(:call).and_return(wallet)
    end

    context 'when wallet is successfully created' do
      let(:wallet) { instance_double(Wallet, save: true, title: 'My Wallet') }
      let(:params) { { wallet: { title: 'My Wallet' } } }

      before { post :create, params: }

      it 'creates a new Wallet' do
        expect(assigns(:wallet)).to eq(wallet)
      end

      it 'redirects to the wallets index page' do
        expect(response).to redirect_to(wallets_path)
        expect(flash[:notice]).to be_present
      end
    end

    context 'when wallet creation fails' do
      let(:wallet) { instance_double(Wallet, save: false, alert_errors: 'Error message') }
      let(:params) { { wallet: { title: '' } } }

      before { post :create, params: }

      it 'does not create a new Wallet' do
        expect { response }.not_to change(Wallet, :count)
      end

      it 'redirects to the wallets index page' do
        expect(response).to redirect_to(wallets_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PATCH #update' do
    let(:wallet) { create(:wallet) }
    let(:valid_params) { attributes_for(:wallet) }
    let(:invalid_params) { attributes_for(:wallet, title: '') }

    before { http_basic_auth }

    context 'with valid parameters' do
      it 'updates the specified Wallet and redirects to the wallets index page with notice' do
        patch :update, params: { id: wallet.id, wallet: valid_params }
        wallet.reload
        expect(wallet.title).to eq(valid_params[:title])
        expect(response).to redirect_to(wallets_path)
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'does not update the specified Wallet and redirects to the wallets index page with alert' do
        patch :update, params: { id: wallet.id, wallet: invalid_params }
        wallet.reload
        expect(wallet.title).not_to eq(invalid_params[:title])
        expect(response).to redirect_to(wallets_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:wallet) { create(:wallet) }

    before { http_basic_auth }

    it 'destroys the requested wallet' do
      expect { delete :destroy, params: { id: wallet.id } }.to change(Wallet, :count).by(-1)
      expect(response).to redirect_to(wallets_path)
      expect(flash[:notice]).to be_present
    end
  end
end
