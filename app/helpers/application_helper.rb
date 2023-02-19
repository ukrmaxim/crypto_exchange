module ApplicationHelper
  include Pagy::Frontend

  def bootstrap_class(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-success',
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def ex_rate
    Setting.find_by(title: 'ex_rate')&.value || 'Parameter not set'
  end

  def ex_fee
    Setting.find_by(title: 'ex_fee')&.value || 'Parameter not set'
  end

  def net_fee
    Setting.find_by(title: 'net_fee')&.value || 'Parameter not set'
  end
end
