module ApplicationHelper
  def bootstrap_class(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-success',
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end
end
