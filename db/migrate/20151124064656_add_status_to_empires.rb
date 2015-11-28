class AddStatusToEmpires < ActiveRecord::Migration
  def change
    add_column :empires, :status, :string
  end
end
