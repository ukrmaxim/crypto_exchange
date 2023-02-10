env :PATH, ENV.fetch('PATH', nil)

set :chronic_options, hours24: true
set :output, 'log/cron_log.log'

every 1.day, at: %w[00:00 12:00] do
  rake 'update:rate'
end

every 1.day, at: %w[00:00 15:00] do
  rake 'update:wallet_balances'
end
