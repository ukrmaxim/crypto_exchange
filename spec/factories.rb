FactoryBot.define do
  factory :setting do
    sequence(:title) { |n| "setting#{n}" }
    value { 'Setting Value' }
  end

  factory :wallet do
    sequence(:title) { |n| "Wallet#{n}" }
    address { Faker::Blockchain::Bitcoin.testnet_address }
    key { Faker::Crypto.sha256 }
    priv_key { Faker::Crypto.sha256 }
    pub_key { Faker::Crypto.sha256 }
    balance { 0.01954054 }
  end

  factory :transaction do
    amount_send { 0.5 }
    amount_get { 0.00001366 }
    recip_email { Faker::Internet.free_email }
    recip_btc_address { Faker::Blockchain::Bitcoin.testnet_address }
    ex_fee { 0.00000061 }
    ex_rate { 0.00004054 }
    net_fee { 0.00000600 }
    kyc { '1' }

    trait :success do
      status { :success }
    end

    trait :fail do
      status { :fail }
    end
  end
end
