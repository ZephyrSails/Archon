class CreateFacilities < ActiveRecord::Migration
  def change
    create_table :facilities do |t|
      t.integer :robotics_factory
      t.integer :shipyard
      t.integer :research_lab
      t.integer :alliance_depot
      t.integer :missile_silo
      t.integer :nanite_factory
      t.integer :terraformer

      t.belongs_to :planet

      t.timestamps
    end
  end
end
