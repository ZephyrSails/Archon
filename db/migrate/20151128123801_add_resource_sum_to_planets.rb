class AddResourceSumToPlanets < ActiveRecord::Migration
  def change
    add_column :planets, :resource_sum, :integer
  end
end
