require 'rails_helper'

RSpec.describe Wallet do
  describe 'validations' do
    let(:wallet) { build(:wallet) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:priv_key) }
    it { is_expected.to validate_presence_of(:pub_key) }
    it { is_expected.to validate_uniqueness_of(:title) }
  end
end
