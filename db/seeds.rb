# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Mode.create(name: "large_cargo_raid", value: 1)

Preference.lc_fleet_count = 10 if Preference.lc_fleet_count == nil
Preference.planets = {  Megathron:  [33716708, "1:410:4"],
                        Hyperion:   [33717412, "1:410:7"],
                        Dominix:    [33717581, "1:216:7"],
                        Nyx:        [33719025, "2:65:8"],
                        Vexor:      [33719845, "1:74:9"],
                        Thanatos:   [33720592, "2:401:10"],
                        Erebus:     [33720852, "7:168:8"]
                      }
Preference.planet_buff = [:Megathron, :Dominix, :Vexor]
Preference.subordinate_planet = [:Dominix, :Vexor]
Preference.mather_planet = :Megathron
Preference.planet_index = 0
Preference.free_slot = 13
Preference.bid_amount = 5999
Preference.center_mode = true
Preference.center_threshold = 2000000
Preference.material_value = [1.0, 2.0, 3.0]
