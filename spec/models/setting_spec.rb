require 'rails_helper'

RSpec.describe Setting do
  describe 'validations' do
    let(:setting) { build(:setting) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
  end

  describe 'callbacks' do
    it 'normalizes the title to lowercase before validation' do
      setting = build(:setting, title: 'TEST_SETTING')
      setting.valid?
      expect(setting.title).to eq('test_setting')
    end
  end
end
