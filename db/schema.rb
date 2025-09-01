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

ActiveRecord::Schema[8.0].define(version: 2025_08_25_153338) do
  create_schema "auth"
  create_schema "extensions"
  create_schema "graphql"
  create_schema "graphql_public"
  create_schema "pgbouncer"
  create_schema "realtime"
  create_schema "storage"
  create_schema "vault"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vault.supabase_vault"

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.string "company"
    t.string "location"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.string "name"
    t.integer "amount"
    t.bigint "shift_id", null: false
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "expensable", default: false
    t.index ["shift_id"], name: "index_expenses_on_shift_id"
  end

  create_table "goals", force: :cascade do |t|
    t.string "title"
    t.date "start_date"
    t.date "finish_date"
    t.integer "target"
    t.string "period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "goal_type"
    t.date "goal_date"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "payslips", force: :cascade do |t|
    t.string "name"
    t.string "month"
    t.string "year"
    t.decimal "gross", precision: 10, scale: 2
    t.decimal "net", precision: 10, scale: 2
    t.integer "hours"
    t.decimal "tax", precision: 10, scale: 2
    t.string "shifts"
    t.integer "rate"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "start"
    t.string "finish"
    t.bigint "user_id"
    t.decimal "year_gross", precision: 10, scale: 2
    t.decimal "year_net", precision: 10, scale: 2
    t.decimal "year_tax", precision: 10, scale: 2
    t.string "username"
    t.index ["user_id"], name: "index_payslips_on_user_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.string "name"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.decimal "rate", precision: 10, scale: 2
    t.decimal "pay", precision: 10, scale: 2
    t.string "notes"
    t.decimal "hours", precision: 5, scale: 2
    t.string "client"
    t.string "location"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.string "company"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_shifts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.date "dob"
    t.string "job"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "member", default: false
    t.date "member_since"
    t.boolean "email_verified", default: false
    t.datetime "password_last_updated"
  end

  add_foreign_key "contacts", "users"
  add_foreign_key "expenses", "shifts"
  add_foreign_key "goals", "users"
  add_foreign_key "payslips", "users"
  add_foreign_key "shifts", "users"
end
