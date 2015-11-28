class CreateFleets < ActiveRecord::Migration
  def change
    create_table :fleets do |t|
      t.integer :light_fighter
      t.integer :heavy_fighter
      t.integer :cruiser
      t.integer :battleship
      t.integer :battlecruiser
      t.integer :bomber
      t.integer :destroyer
      t.integer :death_star
      t.integer :small_cargo
      t.integer :large_cargo
      t.integer :colony_ship
      t.integer :recycler
      t.integer :espionage_probe
      t.integer :solar_satellite

      t.belongs_to :planet, index: true
    end
  end
end
