# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_02_07_112512) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "settings", force: :cascade do |t|
    t.string "title"
    t.string "value"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "unique_setting_title", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.string "recip_email"
    t.decimal "amount_send", precision: 10, scale: 3
    t.decimal "amount_get", precision: 12, scale: 8
    t.string "txid"
    t.string "currency_from"
    t.string "currency_to"
    t.decimal "ex_rate", precision: 12, scale: 8
    t.decimal "ex_fee", precision: 12, scale: 8
    t.decimal "net_fee", precision: 12, scale: 8
    t.string "recip_btc_address"
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wallets", force: :cascade do |t|
    t.string "title"
    t.string "address"
    t.decimal "balance", precision: 12, scale: 8, default: "0.0"
    t.string "key"
    t.string "priv_key"
    t.string "pub_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "unique_wallet_title", unique: true
  end

end
