class AddColumnsToMoons < ActiveRecord::Migration
  def change
    add_column :moons, :name, :string
    add_column :moons, :size, :integer
  end
end
