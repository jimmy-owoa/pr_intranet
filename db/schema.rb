# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_04_10_220203) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.integer "permission", default: 0
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "analytic_visits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "slug"
    t.string "page_type"
    t.datetime "visited_at"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_analytic_visits_on_user_id"
  end

  create_table "chat_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "message"
    t.bigint "room_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_chat_messages_on_room_id"
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
  end

  create_table "chat_rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name"
    t.datetime "closed_at"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_cost_centers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "id_exa"
    t.string "dependence"
  end

  create_table "company_managements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_offices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "address"
    t.bigint "commune_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commune_id"], name: "index_company_offices_on_commune_id"
  end

  create_table "employee_birthdays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee_births", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "child_name"
    t.string "child_lastname"
    t.string "child_lastname2"
    t.boolean "approved", default: false
    t.boolean "gender"
    t.date "birthday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "is_public"
  end

  create_table "expense_report_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expense_report_invoices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.float "total"
    t.text "description"
    t.bigint "category_id"
    t.bigint "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["category_id"], name: "index_expense_report_invoices_on_category_id"
    t.index ["request_id"], name: "index_expense_report_invoices_on_request_id"
  end

  create_table "expense_report_request_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "request_id"
    t.bigint "request_state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.text "comment"
    t.index ["request_id"], name: "index_expense_report_request_histories_on_request_id"
    t.index ["request_state_id"], name: "index_expense_report_request_histories_on_request_state_id"
    t.index ["user_id"], name: "index_expense_report_request_histories_on_user_id"
  end

  create_table "expense_report_request_states", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expense_report_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.text "description"
    t.float "total"
    t.datetime "date"
    t.datetime "closed_at"
    t.bigint "user_id"
    t.integer "divisa_id"
    t.bigint "society_id"
    t.bigint "request_state_id"
    t.bigint "assistant_id"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_local"
    t.integer "destination_country_id"
    t.integer "payment_method_id"
    t.string "bank_account_details"
    t.datetime "payment_date"
    t.datetime "deleted_at"
    t.integer "created_by_id"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_expense_report_requests_on_account_id"
    t.index ["assistant_id"], name: "index_expense_report_requests_on_assistant_id"
    t.index ["country_id"], name: "index_expense_report_requests_on_country_id"
    t.index ["request_state_id"], name: "index_expense_report_requests_on_request_state_id"
    t.index ["society_id"], name: "index_expense_report_requests_on_society_id"
    t.index ["user_id"], name: "index_expense_report_requests_on_user_id"
  end

  create_table "expense_report_subcategories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_expense_report_subcategories_on_category_id"
  end

  create_table "general_backgrounds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.date "starts"
    t.date "ends"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_benefit_group_relationships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "content"
    t.integer "benefit_id"
    t.integer "benefit_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "amount"
    t.string "currency"
    t.string "url"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_general_benefit_group_relationships_on_deleted_at"
  end

  create_table "general_benefit_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_general_benefit_groups_on_deleted_at"
  end

  create_table "general_benefit_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "priority", default: 1
  end

  create_table "general_benefits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "benefit_type_id"
    t.string "code"
    t.string "url"
    t.string "alias"
    t.boolean "is_special"
    t.bigint "menu_id"
    t.boolean "is_transactional", default: false
    t.datetime "deleted_at"
    t.index ["benefit_type_id"], name: "index_general_benefits_on_benefit_type_id"
    t.index ["deleted_at"], name: "index_general_benefits_on_deleted_at"
    t.index ["menu_id"], name: "index_general_benefits_on_menu_id"
  end

  create_table "general_cost_center_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.float "percentage"
    t.bigint "user_id"
    t.bigint "cost_center_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cost_center_id"], name: "index_general_cost_center_users_on_cost_center_id"
    t.index ["user_id"], name: "index_general_cost_center_users_on_user_id"
  end

  create_table "general_daily_informations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "value"
    t.date "date"
    t.string "info_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_economic_indicator_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "symbol"
    t.string "name"
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_economic_indicators", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "date"
    t.integer "economic_indicator_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "value"
  end

  create_table "general_links", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_blank", default: false
    t.bigint "profile_id"
    t.boolean "is_left", default: true
    t.boolean "activated", default: true
    t.index ["profile_id"], name: "index_general_links_on_profile_id"
  end

  create_table "general_locations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_manager_companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "manager_id"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_menus", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "css_class"
    t.integer "code"
    t.integer "priority"
    t.integer "parent_id"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "integration_code"
    t.integer "post_id"
    t.bigint "profile_id"
    t.index ["profile_id"], name: "index_general_menus_on_profile_id"
  end

  create_table "general_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "content", limit: 16777215
    t.string "message_type"
    t.boolean "is_const"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "profile_id"
    t.index ["profile_id"], name: "index_general_messages_on_profile_id"
  end

  create_table "general_notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "viewed_at"
    t.datetime "to_notify_at"
    t.string "notification_type"
    t.string "style"
    t.string "link"
    t.boolean "external_notification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_object_profiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "object"
    t.integer "object_id"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_general_object_profiles_on_profile_id"
  end

  create_table "general_profile_attributes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "class_name"
    t.string "value"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_general_profile_attributes_on_profile_id"
  end

  create_table "general_profiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "attached"
  end

  create_table "general_santorals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "santoral_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_sections", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "position"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_blank", default: false
  end

  create_table "general_societies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.integer "id_exa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_term_relationships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "object_type"
    t.integer "object_id"
    t.integer "term_order"
    t.bigint "term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term_id"], name: "index_general_term_relationships_on_term_id"
  end

  create_table "general_term_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_terms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "term_type_id"
    t.text "description"
    t.integer "parent_id"
    t.string "name"
    t.string "slug"
    t.integer "term_order"
    t.string "status"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "permission"
    t.index ["parent_id"], name: "index_general_terms_on_parent_id"
    t.index ["term_type_id"], name: "index_general_terms_on_term_type_id"
  end

  create_table "general_user_attributes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.string "attribute_name"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_user_book_relationships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id"
    t.integer "book_id"
    t.integer "expiration"
    t.boolean "is_expired", default: false
    t.date "request_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_user_employees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_user_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "viewed_at"
    t.bigint "user_id"
    t.bigint "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_general_user_messages_on_message_id"
    t.index ["user_id"], name: "index_general_user_messages_on_user_id"
  end

  create_table "general_user_notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "seen_at"
    t.datetime "opened_at"
    t.integer "user_id"
    t.integer "notification_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_user_profiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_general_user_profiles_on_profile_id"
    t.index ["user_id"], name: "index_general_user_profiles_on_user_id"
  end

  create_table "general_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "last_name"
    t.string "last_name2", default: ""
    t.boolean "active", default: true
    t.string "annexed"
    t.datetime "birthday"
    t.boolean "show_birthday", default: true
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth"
    t.integer "children_count"
    t.string "position"
    t.string "address"
    t.string "legal_number"
    t.string "legal_number_verification"
    t.integer "location_id"
    t.date "date_entry"
    t.integer "benefit_group_id"
    t.integer "xoops_id"
    t.string "nt_user"
    t.string "gender"
    t.string "position_classification"
    t.string "employee_classification"
    t.string "syndicate_member"
    t.string "rol"
    t.string "civil_status"
    t.string "contract_type"
    t.string "schedule"
    t.boolean "is_boss"
    t.boolean "handicapped"
    t.boolean "has_children"
    t.bigint "cost_center_id"
    t.bigint "management_id"
    t.integer "company_id", default: 0
    t.string "auth_token"
    t.string "favorite_name", default: ""
    t.string "referrer"
    t.datetime "deleted_at"
    t.bigint "answered_form_id"
    t.integer "id_exa"
    t.string "user_code"
    t.integer "id_exa_boss"
    t.bigint "country_id"
    t.bigint "society_id"
    t.integer "supervisor"
    t.index ["answered_form_id"], name: "index_general_users_on_answered_form_id"
    t.index ["cost_center_id"], name: "index_general_users_on_cost_center_id"
    t.index ["country_id"], name: "index_general_users_on_country_id"
    t.index ["deleted_at"], name: "index_general_users_on_deleted_at"
    t.index ["email"], name: "index_general_users_on_email", unique: true
    t.index ["management_id"], name: "index_general_users_on_management_id"
    t.index ["reset_password_token"], name: "index_general_users_on_reset_password_token", unique: true
    t.index ["society_id"], name: "index_general_users_on_society_id"
  end

  create_table "general_users_roles", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_general_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_general_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_general_users_roles_on_user_id"
  end

  create_table "general_weather_informations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "date"
    t.string "max_temp"
    t.string "min_temp"
    t.string "current_temp"
    t.string "condition"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tomorrow_icon"
    t.string "tomorrow_max"
    t.string "tomorrow_min"
    t.string "after_tomorrow_icon"
    t.string "after_tomorrow_max"
    t.string "after_tomorrow_min"
    t.string "aa_tomorrow_icon"
    t.string "aa_tomorrow_max"
    t.string "aa_tomorrow_min"
    t.string "aaa_tomorrow_icon"
    t.string "aaa_tomorrow_max"
    t.string "aaa_tomorrow_min"
    t.integer "location_id"
    t.integer "uv_index"
  end

  create_table "helpcenter_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name", default: ""
    t.string "slug"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_helpcenter_categories_on_profile_id"
  end

  create_table "helpcenter_job_applications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "applicant_name"
    t.string "email"
    t.string "phone"
    t.integer "application_status"
    t.bigint "ticket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_helpcenter_job_applications_on_ticket_id"
  end

  create_table "helpcenter_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.bigint "ticket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_helpcenter_messages_on_ticket_id"
    t.index ["user_id"], name: "index_helpcenter_messages_on_user_id"
  end

  create_table "helpcenter_questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name", default: ""
    t.text "content"
    t.boolean "important", default: false
    t.bigint "subcategory_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subcategory_id"], name: "index_helpcenter_questions_on_subcategory_id"
  end

  create_table "helpcenter_satisfaction_answers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "ticket_id"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_helpcenter_satisfaction_answers_on_ticket_id"
    t.index ["user_id"], name: "index_helpcenter_satisfaction_answers_on_user_id"
  end

  create_table "helpcenter_subcategories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name", default: ""
    t.string "slug"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_helpcenter_subcategories_on_category_id"
  end

  create_table "helpcenter_ticket_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "ticket_id"
    t.bigint "ticket_state_id"
    t.integer "supervisor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_helpcenter_ticket_histories_on_ticket_id"
    t.index ["ticket_state_id"], name: "index_helpcenter_ticket_histories_on_ticket_state_id"
    t.index ["user_id"], name: "index_helpcenter_ticket_histories_on_user_id"
  end

  create_table "helpcenter_ticket_states", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "helpcenter_tickets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.text "description"
    t.string "status"
    t.boolean "created_by_admin", default: false
    t.datetime "closed_at"
    t.datetime "attended_at"
    t.bigint "user_id"
    t.bigint "assistant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "subcategory_id"
    t.boolean "aproved_to_review", default: true
    t.integer "amount"
    t.string "currency_type"
    t.integer "character_of_process"
    t.integer "recruitment_source"
    t.integer "reason_for_search"
    t.integer "number_of_vacancies"
    t.integer "area"
    t.integer "company"
    t.integer "required_education"
    t.text "cost_center"
    t.integer "careers"
    t.integer "years_of_experience"
    t.integer "job_location"
    t.integer "work_schedule"
    t.integer "shift"
    t.text "observation"
    t.date "admission_date"
    t.integer "income_composition"
    t.integer "requires_account"
    t.integer "requires_computer"
    t.date "request_date"
    t.integer "requested_position_title"
    t.integer "replacement_user_id"
    t.index ["assistant_id"], name: "index_helpcenter_tickets_on_assistant_id"
    t.index ["subcategory_id"], name: "index_helpcenter_tickets_on_subcategory_id"
    t.index ["user_id"], name: "index_helpcenter_tickets_on_user_id"
  end

  create_table "library_authors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "library_books", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "edition"
    t.integer "publication_year"
    t.integer "stock"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "author_id"
    t.bigint "editorial_id"
    t.boolean "available", default: false
    t.bigint "category_book_id"
    t.index ["author_id"], name: "index_library_books_on_author_id"
    t.index ["category_book_id"], name: "index_library_books_on_category_book_id"
    t.index ["editorial_id"], name: "index_library_books_on_editorial_id"
  end

  create_table "library_category_books", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "library_editorials", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "location_cities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_location_cities_on_region_id"
  end

  create_table "location_communes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_location_communes_on_city_id"
  end

  create_table "location_countries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "location_regions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_location_regions_on_country_id"
  end

  create_table "marketplace_products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "product_type"
    t.string "currency"
    t.integer "price"
    t.string "email"
    t.integer "phone"
    t.string "location"
    t.integer "expiration"
    t.boolean "approved", default: false
    t.boolean "is_expired", default: false
    t.date "published_date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "path"
    t.string "dimension"
    t.boolean "is_public"
    t.string "attachable_type"
    t.bigint "attachable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "caption"
    t.string "xoops_attachment_name"
    t.index ["attachable_type", "attachable_id"], name: "index_media_attachments_on_attachable_type_and_attachable_id"
  end

  create_table "media_files", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media_galleries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "post_id"
  end

  create_table "media_galleries_news_posts", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "gallery_id"
    t.bigint "post_id"
    t.index ["gallery_id"], name: "index_media_galleries_news_posts_on_gallery_id"
    t.index ["post_id"], name: "index_media_galleries_news_posts_on_post_id"
  end

  create_table "media_gallery_relations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "gallery_id"
    t.integer "attachment_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gallery_id", "attachment_id"], name: "index_media_gallery_relations_on_gallery_id_and_attachment_id"
  end

  create_table "menu_exas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_menu_exas_on_user_id"
  end

  create_table "news_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name", limit: 191
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.integer "parent_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_news_comments_on_post_id"
    t.index ["user_id"], name: "index_news_comments_on_user_id"
  end

  create_table "news_interactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "interaction_type", default: ""
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_news_interactions_on_post_id"
    t.index ["user_id"], name: "index_news_interactions_on_user_id"
  end

  create_table "news_meta", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "object_type"
    t.integer "object_id"
    t.string "key"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news_posts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.text "content", limit: 16777215
    t.string "status"
    t.datetime "published_at"
    t.bigint "main_image_id"
    t.bigint "term_id"
    t.integer "post_parent_id"
    t.string "visibility"
    t.string "post_class"
    t.integer "post_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "user_id"
    t.string "post_type"
    t.integer "format"
    t.boolean "important", default: false
    t.string "permission"
    t.text "extract"
    t.integer "former_id"
    t.integer "migrated_id"
    t.string "migrated_image_filename"
    t.integer "xoops_topic_id"
    t.bigint "profile_id"
    t.bigint "file_video_id"
    t.boolean "accept_comments", default: true
    t.boolean "accept_interactions", default: true
    t.index ["deleted_at"], name: "index_news_posts_on_deleted_at"
    t.index ["file_video_id"], name: "index_news_posts_on_file_video_id"
    t.index ["main_image_id"], name: "index_news_posts_on_main_image_id"
    t.index ["post_parent_id"], name: "index_news_posts_on_post_parent_id"
    t.index ["profile_id"], name: "index_news_posts_on_profile_id"
    t.index ["term_id"], name: "index_news_posts_on_term_id"
  end

  create_table "payment_accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name"
    t.string "account_number"
    t.string "email"
    t.string "legal_number"
    t.string "bank_name"
    t.string "account_type"
    t.string "country"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_payment_accounts_on_user_id"
  end

  create_table "personal_data_education_institutions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "personal_data_education_states", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "personal_data_family_members", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "relation"
    t.string "gender"
    t.date "birthdate"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_personal_data_family_members_on_user_id"
  end

  create_table "personal_data_home_addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "address"
    t.bigint "commune_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commune_id"], name: "index_personal_data_home_addresses_on_commune_id"
  end

  create_table "personal_data_language_levels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "personal_data_languages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "personal_data_user_educations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "education_state_id"
    t.bigint "education_institution_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["education_institution_id"], name: "index_personal_data_user_educations_on_education_institution_id"
    t.index ["education_state_id"], name: "index_personal_data_user_educations_on_education_state_id"
    t.index ["user_id"], name: "index_personal_data_user_educations_on_user_id"
  end

  create_table "personal_data_user_languages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "language_id"
    t.bigint "language_level_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_personal_data_user_languages_on_language_id"
    t.index ["language_level_id"], name: "index_personal_data_user_languages_on_language_level_id"
    t.index ["user_id"], name: "index_personal_data_user_languages_on_user_id"
  end

  create_table "religion_gospels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label_name", default: ""
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "survey_answered_forms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "survey_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_survey_answered_forms_on_survey_id"
    t.index ["user_id"], name: "index_survey_answered_forms_on_user_id"
  end

  create_table "survey_answered_times", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_survey_answered_times_on_survey_id"
  end

  create_table "survey_answers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "question_id"
    t.bigint "option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "answer_variable"
    t.bigint "answered_form_id"
    t.index ["answered_form_id"], name: "index_survey_answers_on_answered_form_id"
    t.index ["option_id"], name: "index_survey_answers_on_option_id"
    t.index ["question_id"], name: "index_survey_answers_on_question_id"
    t.index ["user_id"], name: "index_survey_answers_on_user_id"
  end

  create_table "survey_options", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.boolean "default"
    t.string "placeholder"
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_survey_options_on_question_id"
  end

  create_table "survey_questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "question_type"
    t.bigint "survey_id"
    t.boolean "required", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_survey_questions_on_survey_id"
  end

  create_table "survey_surveys", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "survey_type"
    t.string "status"
    t.text "description"
    t.date "finish_date"
    t.datetime "published_at"
    t.boolean "show_name", default: true
    t.boolean "once_by_user", default: true
    t.integer "allowed_answers", default: 0
    t.string "slug"
    t.string "string"
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_survey_surveys_on_deleted_at"
    t.index ["profile_id"], name: "index_survey_surveys_on_profile_id"
    t.index ["slug"], name: "index_survey_surveys_on_slug", unique: true
  end

  add_foreign_key "general_term_relationships", "general_terms", column: "term_id"
  add_foreign_key "general_terms", "general_term_types", column: "term_type_id"
  add_foreign_key "news_posts", "general_terms", column: "term_id"
  add_foreign_key "news_posts", "media_attachments", column: "file_video_id"
  add_foreign_key "news_posts", "media_attachments", column: "main_image_id"
end
