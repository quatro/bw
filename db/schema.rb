# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_02_212804) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "booking_request_rooms", force: :cascade do |t|
    t.integer "booking_request_id"
    t.integer "guest1_id"
    t.integer "gues2_id"
  end

  create_table "booking_requests", force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "requestor_id"
    t.bigint "assignee_id"
    t.date "date_from"
    t.date "date_to"
    t.string "reason"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "job_identifier"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "client_id"
    t.integer "nights"
    t.string "requestor_name"
    t.string "address"
    t.integer "number_of_rooms"
    t.index ["assignee_id"], name: "index_booking_requests_on_assignee_id"
    t.index ["client_id"], name: "index_booking_requests_on_client_id"
    t.index ["requestor_id"], name: "index_booking_requests_on_requestor_id"
    t.index ["tenant_id"], name: "index_booking_requests_on_tenant_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "booking_request_id"
    t.bigint "requestor_id"
    t.string "confirmation_number", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "client_id"
    t.bigint "hotel_id"
    t.bigint "assignee_id"
    t.decimal "rate", precision: 8, scale: 2
    t.decimal "tax", precision: 8, scale: 2
    t.decimal "total", precision: 8, scale: 2
    t.boolean "is_booked", default: false
    t.decimal "license_fee"
    t.integer "annual_booking_number"
    t.decimal "license_fee_percentage", default: "0.0"
    t.boolean "is_cancelled", default: false
    t.boolean "is_no_show", default: false
    t.bigint "cancelled_by_user_id"
    t.index ["assignee_id"], name: "index_bookings_on_assignee_id"
    t.index ["booking_request_id"], name: "index_bookings_on_booking_request_id"
    t.index ["cancelled_by_user_id"], name: "index_bookings_on_cancelled_by_user_id"
    t.index ["client_id"], name: "index_bookings_on_client_id"
    t.index ["hotel_id"], name: "index_bookings_on_hotel_id"
    t.index ["requestor_id"], name: "index_bookings_on_requestor_id"
    t.index ["tenant_id"], name: "index_bookings_on_tenant_id"
  end

  create_table "clients", force: :cascade do |t|
    t.bigint "tenant_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tenant_id"], name: "index_clients_on_tenant_id"
  end

  create_table "hotels", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.bigint "tenant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "rate", precision: 8, scale: 2
    t.string "lat"
    t.string "lng"
    t.string "phone_number"
    t.date "contract_start_date"
    t.date "contract_end_date"
    t.index ["tenant_id"], name: "index_hotels_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "from_email"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first"
    t.string "last"
    t.string "api_key"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tenant_id"
    t.bigint "client_id"
    t.boolean "is_foreman"
    t.index ["client_id"], name: "index_users_on_client_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

end
