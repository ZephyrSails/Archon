class AddResourceToResource < ActiveRecord::Migration
  def change
    add_column :resources, :metal, :integer
    add_column :resources, :crystal, :integer
    add_column :resources, :deuterium, :integer
  end
end
