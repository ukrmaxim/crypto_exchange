class SettingsController < ApplicationController
  before_action :set_setting, only: %i[update destroy]
  http_basic_authenticate_with name: Rails.application.credentials.dig(:http_auth, :name),
                               password: Rails.application.credentials.dig(:http_auth, :password)

  # GET /settings
  def index
    @settings = Setting.all

    render locals: { settings: @settings, new_setting: Setting.new }
  end

  # POST /settings
  def create
    @setting = Setting.new(setting_params)

    if @setting.save
      redirect_to settings_path, notice: "Setting parametr '#{@setting.title}' was successfully created."
    else
      redirect_to settings_path, alert: @setting.alert_errors
    end
  end

  # PATCH/PUT /settings/1
  def update
    if @setting.update(setting_params)
      redirect_to settings_path, notice: "Setting parametr '#{@setting.title}' was successfully updated."
    else
      redirect_to settings_path, alert: @setting.alert_errors
    end
  end

  # DELETE /settings/1
  def destroy
    @setting.destroy
    redirect_to settings_url, notice: 'Setting parametr was successfully destroyed.'
  end

  private

  def set_setting
    @setting = Setting.find(params[:id])
  end

  def setting_params
    params.require(:setting).permit(:title, :value, :description)
  end
end
