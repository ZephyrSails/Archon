class DropGalaxys < ActiveRecord::Migration
  def change
    drop_table :galaxys
  end
end
