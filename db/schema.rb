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

ActiveRecord::Schema.define(version: 2018_05_23_135322) do

  create_table "kickstarter_datas", force: :cascade do |t|
    t.string "country"
    t.string "category"
    t.integer "year"
    t.integer "month"
    t.integer "backers_count"
    t.float "usd_pledged"
    t.float "avg_pledge"
    t.string "url"
    t.integer "record_id"
    t.index ["record_id"], name: "index_kickstarter_datas_on_record_id", unique: true
  end

end
