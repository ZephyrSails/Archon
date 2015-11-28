class AddSpylabelToPlanets < ActiveRecord::Migration
  def change
    add_column :planets, :counter_espionage, :integer
    add_column :planets, :fleets_value, :integer
    add_column :planets, :defence_value, :integer
    add_column :planets, :resource_value, :integer
    add_column :planets, :loot, :integer
    add_column :planets, :activity, :string
  end
end
