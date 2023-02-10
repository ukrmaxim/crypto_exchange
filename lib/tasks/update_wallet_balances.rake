namespace :update do
  desc 'Update wallet balances'
  task wallet_balances: :environment do
    CheckBalanceService.new.call
  end
end
