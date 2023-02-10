class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def alert_errors
    errors.full_messages.join(' | ')
  end
end
