puts 'Seeding...'
Setting.create([{ title: 'ex_wallet', value: 'your bitcoin address', description: 'Wallet for exchanger' },
                { title: 'ex_fee', value: '3', description: 'Exchange fee (in %)' },
                { title: 'ex_rate', value: '0.00004046', description: 'Exchange rate (in BTC)' },
                { title: 'net_fee', value: '0.00000600', description: 'Network fee (in BTC)' }])
puts 'Seeding done.'
