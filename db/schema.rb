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

ActiveRecord::Schema.define(version: 20151127072101) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "empires", force: :cascade do |t|
    t.string   "email"
    t.string   "pass"
    t.string   "universe"
    t.integer  "rank"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_id"
    t.integer  "galaxy_id"
    t.string   "status"
    t.string   "name"
    t.integer  "score_economy"
    t.integer  "score_research"
    t.integer  "score_military"
    t.integer  "score_military_lost"
    t.integer  "score_military_build"
    t.integer  "score_military_destroyed"
    t.integer  "honor_point"
  end

  add_index "empires", ["api_id"], name: "index_empires_on_api_id"
  add_index "empires", ["galaxy_id"], name: "index_empires_on_galaxy_id"

  create_table "facilities", force: :cascade do |t|
    t.integer  "robotics_factory"
    t.integer  "shipyard"
    t.integer  "research_lab"
    t.integer  "alliance_depot"
    t.integer  "missile_silo"
    t.integer  "nanite_factory"
    t.integer  "terraformer"
    t.integer  "planet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fleets", force: :cascade do |t|
    t.integer  "light_fighter"
    t.integer  "heavy_fighter"
    t.integer  "cruiser"
    t.integer  "battleship"
    t.integer  "battlecruiser"
    t.integer  "bomber"
    t.integer  "destroyer"
    t.integer  "death_star"
    t.integer  "small_cargo"
    t.integer  "large_cargo"
    t.integer  "colony_ship"
    t.integer  "recycler"
    t.integer  "espionage_probe"
    t.integer  "solar_satellite"
    t.integer  "planet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fleets", ["planet_id"], name: "index_fleets_on_planet_id"

  create_table "galaxies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code"
  end

  create_table "moons", force: :cascade do |t|
    t.integer  "planet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_id"
    t.string   "name"
    t.integer  "size"
  end

  add_index "moons", ["planet_id"], name: "index_moons_on_planet_id"

  create_table "planets", force: :cascade do |t|
    t.string   "diameter"
    t.string   "temperature"
    t.string   "position"
    t.string   "name"
    t.string   "size"
    t.string   "size_max"
    t.integer  "empire_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_id"
    t.integer  "counter_espionage"
    t.integer  "fleets_value"
    t.integer  "defence_value"
    t.integer  "resource_value"
    t.integer  "loot"
    t.string   "activity"
  end

  add_index "planets", ["empire_id"], name: "index_planets_on_empire_id"
  add_index "planets", ["id"], name: "index_planets_on_id"
  add_index "planets", ["position"], name: "index_planets_on_position"

  create_table "resources", force: :cascade do |t|
    t.string   "name"
    t.integer  "available"
    t.float    "production"
    t.integer  "max"
    t.integer  "den"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "metal_mine"
    t.integer  "crystal_mine"
    t.integer  "deuterium_synthesizer"
    t.integer  "solar_plant"
    t.integer  "fusion_reactor"
    t.integer  "solar_satellite"
    t.integer  "metal_storage"
    t.integer  "crystal_storage"
    t.integer  "deuterium_tank"
    t.integer  "planet_id"
    t.integer  "metal"
    t.integer  "crystal"
    t.integer  "deuterium"
  end

  add_index "resources", ["planet_id"], name: "index_resources_on_planet_id"

  create_table "schdules", force: :cascade do |t|
    t.integer  "empire_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "launch_time"
    t.string   "order"
  end

  add_index "schdules", ["empire_id"], name: "index_schdules_on_empire_id"

  create_table "technologies", force: :cascade do |t|
    t.integer  "energy_technology"
    t.integer  "laser_technology"
    t.integer  "ion_technology"
    t.integer  "hyperspace_technology"
    t.integer  "plasma_technology"
    t.integer  "combustion_drive"
    t.integer  "impulse_drive"
    t.integer  "hyperspace_drive"
    t.integer  "espionage_technology"
    t.integer  "computer_technology"
    t.integer  "astrophysics"
    t.integer  "intergalactic_research_network"
    t.integer  "graviton_technology"
    t.integer  "weapons_technology"
    t.integer  "shielding_technology"
    t.integer  "armour_technology"
    t.integer  "empire_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
