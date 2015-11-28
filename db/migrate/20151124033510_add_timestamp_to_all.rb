class AddTimestampToAll < ActiveRecord::Migration
  def change
    add_timestamps :empires
    add_timestamps :planets
    add_timestamps :galaxys
    add_timestamps :fleets
    add_timestamps :schdules
    add_timestamps :moons
    add_timestamps :technologies
  end
end
