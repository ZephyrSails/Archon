class AddIndexToEmpires < ActiveRecord::Migration
  def change
    add_index :empires, :api_id
  end
end
