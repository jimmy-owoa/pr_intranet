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

ActiveRecord::Schema.define(version: 2019_08_08_211801) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.integer "permission", default: 0
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "ahoy_events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.json "properties"
    t.timestamp "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.timestamp "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "employee_birthdays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee_births", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "full_name_mother"
    t.string "full_name_father"
    t.string "child_name"
    t.string "child_lastname"
    t.boolean "approved", default: false
    t.boolean "gender"
    t.date "birthday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "child_lastname2"
    t.integer "user_id"
    t.boolean "is_public"
  end

  create_table "general_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "path"
    t.string "dimension"
    t.boolean "is_public"
    t.string "attachable_type"
    t.bigint "attachable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "caption"
    t.integer "xoops_attachment_id"
    t.string "xoops_attachment_name"
    t.index ["attachable_type", "attachable_id"], name: "index_general_attachments_on_attachable_type_and_attachable_id"
  end

  create_table "general_benefit_group_relationships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "content"
    t.integer "benefit_id"
    t.integer "benefit_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "amount"
    t.string "currency"
    t.string "url"
  end

  create_table "general_benefit_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_benefit_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
  end

  create_table "general_benefits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "benefit_type_id"
    t.string "code"
    t.string "url"
    t.string "alias"
    t.boolean "is_special"
    t.index ["benefit_type_id"], name: "index_general_benefits_on_benefit_type_id"
  end

  create_table "general_daily_informations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "value"
    t.date "date"
    t.string "info_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_economic_indicator_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "symbol"
    t.string "name"
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_economic_indicators", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "date"
    t.integer "economic_indicator_type_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_files", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_galleries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "post_id"
    t.integer "xoops_gallery_id"
  end

  create_table "general_galleries_news_posts", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "gallery_id"
    t.bigint "post_id"
    t.index ["gallery_id"], name: "index_general_galleries_news_posts_on_gallery_id"
    t.index ["post_id"], name: "index_general_galleries_news_posts_on_post_id"
  end

  create_table "general_gallery_relations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "gallery_id"
    t.integer "attachment_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gallery_id", "attachment_id"], name: "index_general_gallery_relations_on_gallery_id_and_attachment_id"
  end

  create_table "general_links", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_locations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_menus", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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
  end

  create_table "general_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "message_type"
    t.boolean "is_const"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "viewed_at"
    t.datetime "to_notify_at"
    t.string "notification_type"
    t.string "style"
    t.string "link"
    t.boolean "external_notification"
    t.integer "user_id"
    t.integer "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_santorals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "santoral_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_sections", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "position"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_term_relationships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_type"
    t.integer "object_id"
    t.integer "term_order"
    t.bigint "term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["term_id"], name: "index_general_term_relationships_on_term_id"
  end

  create_table "general_term_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_terms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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

  create_table "general_user_employees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "last_name"
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
    t.string "company"
    t.string "position"
    t.string "address"
    t.string "legal_number"
    t.string "legal_number_verification"
    t.integer "location_id"
    t.date "date_entry"
    t.integer "benefit_group_id"
    t.integer "xoops_id"
    t.string "last_name2"
    t.string "nt_user"
    t.index ["email"], name: "index_general_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_general_users_on_reset_password_token", unique: true
  end

  create_table "general_users_roles", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_general_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_general_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_general_users_roles_on_user_id"
  end

  create_table "general_weather_informations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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
    t.integer "uv_index"
    t.integer "location_id"
  end

  create_table "marketplace_products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "product_type"
    t.decimal "price", precision: 15, scale: 2
    t.string "email"
    t.integer "phone"
    t.string "location"
    t.integer "expiration"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "is_expired", default: false
    t.date "published_date"
    t.string "currency"
    t.integer "xoops_product_id"
  end

  create_table "news_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "user_ip"
    t.text "content"
    t.boolean "approved"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_news_comments_on_post_id"
  end

  create_table "news_meta", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_type"
    t.integer "object_id"
    t.string "key"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news_posts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.text "content"
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
    t.index ["deleted_at"], name: "index_news_posts_on_deleted_at"
    t.index ["main_image_id"], name: "index_news_posts_on_main_image_id"
    t.index ["post_parent_id"], name: "index_news_posts_on_post_parent_id"
    t.index ["term_id"], name: "index_news_posts_on_term_id"
  end

  create_table "religion_gospels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "survey_answers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "question_id"
    t.bigint "option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "answer_variable"
    t.index ["option_id"], name: "index_survey_answers_on_option_id"
    t.index ["question_id"], name: "index_survey_answers_on_question_id"
    t.index ["user_id"], name: "index_survey_answers_on_user_id"
  end

  create_table "survey_options", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.boolean "default"
    t.string "placeholder"
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_survey_options_on_question_id"
  end

  create_table "survey_questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "question_type"
    t.bigint "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "optional", default: false
    t.index ["survey_id"], name: "index_survey_questions_on_survey_id"
  end

  create_table "survey_surveys", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "survey_type"
    t.string "slug"
    t.boolean "show_name", default: true
    t.text "description"
    t.boolean "once_by_user", default: true
    t.datetime "published_at"
    t.string "status"
    t.integer "xoops_survey_id"
    t.index ["slug"], name: "index_survey_surveys_on_slug", unique: true
  end

  add_foreign_key "general_term_relationships", "general_terms", column: "term_id"
  add_foreign_key "general_terms", "general_term_types", column: "term_type_id"
  add_foreign_key "news_comments", "news_posts", column: "post_id"
  add_foreign_key "news_posts", "general_attachments", column: "main_image_id"
  add_foreign_key "news_posts", "general_terms", column: "term_id"
end
