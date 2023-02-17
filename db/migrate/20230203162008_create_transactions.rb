class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :recip_email
      t.decimal :amount_send, precision: 10, scale: 3
      t.decimal :amount_get, precision: 12, scale: 8
      t.string :txid
      t.string :currency_from
      t.string :currency_to
      t.decimal :ex_rate, precision: 12, scale: 8
      t.decimal :ex_fee, precision: 12, scale: 8
      t.decimal :net_fee, precision: 12, scale: 8
      t.string :recip_btc_address
      t.integer :status, null: false

      t.timestamps
    end
  end
end
