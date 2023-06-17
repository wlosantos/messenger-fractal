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

ActiveRecord::Schema[7.0].define(version: 20_230_617_180_605) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index %w[name resource_type resource_id], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index %w[resource_type resource_id], name: "index_roles_on_resource"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name", null: false
    t.integer "kind", default: 0, null: false
    t.boolean "read_only", default: false, null: false
    t.boolean "moderated", default: false, null: false
    t.bigint "origin_id", null: false
    t.bigint "moderator_id"
    t.bigint "app_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_rooms_on_app_id"
    t.index ["moderator_id"], name: "index_rooms_on_moderator_id"
    t.index ["origin_id"], name: "index_rooms_on_origin_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "fractal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["fractal_id"], name: "index_users_on_fractal_id", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index %w[user_id role_id], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "rooms", "apps"
  add_foreign_key "rooms", "users", column: "moderator_id"
  add_foreign_key "rooms", "users", column: "origin_id"
end
