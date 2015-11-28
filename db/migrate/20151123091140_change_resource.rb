class ChangeResource < ActiveRecord::Migration
  def change
    change_column :resources, :production, :float
    rename_column :resources, :limit, :max
  end
end
