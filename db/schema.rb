# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140410083424) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "frames", force: true do |t|
    t.integer  "user_game_relation_id"
    t.integer  "first_try_score"
    t.integer  "second_try_score"
    t.integer  "position",              default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string   "status",                             null: false
    t.integer  "current_player_id"
    t.integer  "current_frame_position", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_game_relations", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "position",    default: 1
    t.integer  "total_score", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
