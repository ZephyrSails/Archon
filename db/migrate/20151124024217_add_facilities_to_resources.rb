class AddFacilitiesToResources < ActiveRecord::Migration
  def change
    add_column :resources, :metal_mine, :integer
    add_column :resources, :crystal_mine, :integer
    add_column :resources, :deuterium_synthesizer, :integer
    add_column :resources, :solar_plant, :integer
    add_column :resources, :fusion_reactor, :integer
    add_column :resources, :solar_satellite, :integer
    add_column :resources, :metal_storage, :integer
    add_column :resources, :crystal_storage, :integer
    add_column :resources, :deuterium_tank, :integer

    add_reference :resources, :planet, index: true
  end
end
