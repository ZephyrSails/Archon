class AddApiId < ActiveRecord::Migration
  def change
    add_column :empires, :api_id, :string
    add_column :planets, :api_id, :string
    add_column :galaxys, :api_id, :string
    add_column :moons, :api_id, :string
  end
end
