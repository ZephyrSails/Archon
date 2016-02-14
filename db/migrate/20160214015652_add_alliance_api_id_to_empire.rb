class AddAllianceApiIdToEmpire < ActiveRecord::Migration
  def change
    add_column :empires, :alliance_api_id, :string
  end
end
