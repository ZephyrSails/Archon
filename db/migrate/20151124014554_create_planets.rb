class CreatePlanets < ActiveRecord::Migration
  def change
    create_table :planets do |t|
      t.string :diameter
      t.string :temperature
      t.string :position
      t.string :name
      t.string :size
      t.string :size_max

      t.belongs_to :empire, index: true
      # t.belongs_to :galaxy


    end
  end
end
