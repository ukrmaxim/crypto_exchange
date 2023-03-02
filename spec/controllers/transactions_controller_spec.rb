require 'rails_helper'
require 'support/auth_spec_helper'
require 'support/transactions_spec_helper'

RSpec.describe TransactionsController do
  before do
    settings
  end

  describe 'GET #index' do
    let(:transaction) { create(:transaction, status: 0) }

    it 'requires authentication' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it 'assigns all transaction to @transactions' do
      http_basic_auth
      get :index
      expect(assigns(:transactions)).to eq([transaction])
    end

    it 'renders the index template' do
      http_basic_auth
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET #show' do
    let(:transaction) { create(:transaction, status: 0) }

    before { http_basic_auth }

    it 'assigns @transaction' do
      get :show, params: { id: transaction.id }
      expect(assigns(:transaction)).to eq(transaction)
    end

    it 'renders the show template' do
      get :show, params: { id: transaction.id }
      expect(response).to render_template('show')
    end
  end

  describe 'GET #new' do
    it 'assigns a new transaction to @transaction' do
      get :new
      expect(assigns(:transaction)).to be_a_new(Transaction)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    let(:valid_params) { attributes_for(:transaction) }
    let(:invalid_params) { attributes_for(:transaction, kyc: '') }

    let(:create_transaction_service) { instance_double(CreateTransactionService, call: { id: 123 }) }
    let(:broadcast_transaction_service) {
      instance_double(BroadcastTransactionService, call: create_transaction_service.call)
    }

    before do
      allow(CreateTransactionService).to receive(:new).and_return(create_transaction_service)
      allow(BroadcastTransactionService).to receive(:new).and_return(broadcast_transaction_service)
    end

    context 'with valid params' do
      it 'creates a new Transaction and redirects to the show page' do
        post :create, params: { transaction: valid_params }

        expect(response).to redirect_to(transaction_path('123'))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON error' do
        post :create, params: { transaction: invalid_params }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'errors' => [{ 'detail' => 'Kyc must be accepted',
                                                                 'type' => 'kyc' }] })
      end
    end
  end
end
