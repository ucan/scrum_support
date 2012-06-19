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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120618063051) do

  create_table "memberships", :force => true do |t|
    t.integer  "project_id"
    t.integer  "person_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "memberships", ["project_id", "person_id"], :name => "index_memberships_on_project_id_and_person_id", :unique => true

  create_table "people", :force => true do |t|
    t.string   "firstName"
    t.string   "lastName"
    t.string   "email"
    t.string   "userName"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stories", :force => true do |t|
    t.integer  "project_id"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
