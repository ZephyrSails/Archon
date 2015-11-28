class AddIndexToPlanets < ActiveRecord::Migration
  def change
    add_index :planets, :position
    add_index :planets, :id
    # add_index :planets, :empire_id
  end
end
