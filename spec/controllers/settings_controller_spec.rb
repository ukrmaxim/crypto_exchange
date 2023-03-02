require 'rails_helper'
require 'support/auth_spec_helper'

RSpec.describe SettingsController do
  describe 'GET #index' do
    let(:setting) { create(:setting) }

    it 'requires authentication' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it 'assigns all settings to @settings' do
      http_basic_auth
      get :index
      expect(assigns(:settings)).to eq([setting])
    end

    it 'assigns a new Setting to new_setting' do
      http_basic_auth
      get :index
      expect(assigns(:new_setting)).to be_a_new(Setting)
    end
  end

  describe 'POST #create' do
    let(:valid_params) { attributes_for(:setting) }
    let(:invalid_params) { attributes_for(:setting, title: '') }

    before { http_basic_auth }

    context 'with valid parameters' do
      it 'creates a new Setting' do
        expect {
          post :create, params: { setting: valid_params }
        }.to change(Setting, :count).by(1)
      end

      it 'redirects to the settings index page' do
        post :create, params: { setting: valid_params }
        expect(response).to redirect_to(settings_path)
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Setting' do
        expect {
          post :create, params: { setting: invalid_params }
        }.not_to change(Setting, :count)
      end

      it 'redirects to the settings index page' do
        post :create, params: { setting: invalid_params }
        expect(response).to redirect_to(settings_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PATCH #update' do
    let(:setting) { create(:setting) }
    let(:valid_params) { attributes_for(:setting) }
    let(:invalid_params) { attributes_for(:setting, title: '') }

    before { http_basic_auth }

    context 'with valid parameters' do
      it 'updates the specified Setting and redirects to the settings index page with notice' do
        patch :update, params: { id: setting.id, setting: valid_params }
        setting.reload
        expect(setting.title).to eq(valid_params[:title])
        expect(response).to redirect_to(settings_path)
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'does not update the specified Setting and redirects to the settings index page with alert' do
        patch :update, params: { id: setting.id, setting: invalid_params }
        setting.reload
        expect(setting.title).not_to eq(invalid_params[:title])
        expect(response).to redirect_to(settings_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:setting) { create(:setting) }

    before { http_basic_auth }

    it 'destroys the requested setting' do
      expect { delete :destroy, params: { id: setting.id } }.to change(Setting, :count).by(-1)
      expect(response).to redirect_to(settings_path)
      expect(flash[:notice]).to be_present
    end
  end
end
