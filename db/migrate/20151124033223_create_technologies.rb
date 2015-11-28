class CreateTechnologies < ActiveRecord::Migration
  def change
    create_table :technologies do |t|
      t.integer :energy_technology
      t.integer :laser_technology
      t.integer :ion_technology
      t.integer :hyperspace_technology
      t.integer :plasma_technology
      t.integer :combustion_drive
      t.integer :impulse_drive
      t.integer :hyperspace_drive
      t.integer :espionage_technology
      t.integer :computer_technology
      t.integer :astrophysics
      t.integer :intergalactic_research_network
      t.integer :graviton_technology
      t.integer :weapons_technology
      t.integer :shielding_technology
      t.integer :armour_technology

      t.belongs_to :empire
    end
  end
end
