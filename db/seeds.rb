puts 'Seeding...'
Setting.create([{ title: 'ex_wallet', value: 'your bitcoin address', desc: 'Wallet for exchanger' },
                { title: 'ex_fee', value: '3', desc: 'Exchange fee (in %)' },
                { title: 'ex_rate', value: '0.00004046', desc: 'Exchange rate (in BTC)' },
                { title: 'net_fee', value: '0.00000600', desc: 'Network fee (in BTC)' }])
puts 'Seeding done.'
