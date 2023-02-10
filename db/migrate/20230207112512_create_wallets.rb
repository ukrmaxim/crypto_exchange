class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.string :title, index: { unique: true, name: 'unique_wallet_title' }
      t.string :address
      t.decimal :balance, precision: 12, scale: 8, default: 0
      t.string :key
      t.string :priv_key
      t.string :pub_key

      t.timestamps
    end
  end
end
