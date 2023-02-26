module TransactionsHelper
  def settings
    create(:setting, title: 'ex_rate', value: '0.00004054')
    create(:setting, title: 'ex_fee', value: '0.00000061')
    create(:setting, title: 'net_fee', value: '0.00000600')
    create(:setting, title: 'ex_wallet', value: 'mg1eiohebTsKsmr2UyrzojYLpg6EMqYMLA')
    create(:wallet, title: 'ex_wallet', address: 'mg1eiohebTsKsmr2UyrzojYLpg6EMqYMLA',
                    key: 'cTtddUTPsyDsvTThnhgh4x8U8tkhZdkeCEz21LxdLT4j8j7GYkh3',
                    priv_key: 'bc3fa53a7bc8cd7198c64b8bdd425cd0a3b5f451bc6c951f73b31a37075e6fee',
                    pub_key: '0353b4fcc744176ab284f20231c954401177e9cfc17aaa907554fae82e734ad475',
                    balance: 0.01954054)
  end
end

RSpec.configure do |config|
  config.include TransactionsHelper
end
