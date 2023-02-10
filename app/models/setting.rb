class Setting < ApplicationRecord
  encrypts :title, deterministic: true
  encrypts :value

  before_validation :normalize_title

  validates :title, :value, presence: true
  validates :title, uniqueness: true

  private

  def normalize_title
    title.downcase!
  end
end
