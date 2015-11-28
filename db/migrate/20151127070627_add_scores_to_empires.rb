class AddScoresToEmpires < ActiveRecord::Migration
  def change
    add_column :empires, :score_economy, :integer
    add_column :empires, :score_research, :integer
    add_column :empires, :score_military, :integer
    add_column :empires, :score_military_lost, :integer
    add_column :empires, :score_military_build, :integer
    add_column :empires, :score_military_destroyed, :integer
    add_column :empires, :honor_point, :integer
  end
end
