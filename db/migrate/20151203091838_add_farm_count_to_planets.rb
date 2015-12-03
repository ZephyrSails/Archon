class AddFarmCountToPlanets < ActiveRecord::Migration
  def change
    add_column :planets, :farm_count, :integer
  end
end
