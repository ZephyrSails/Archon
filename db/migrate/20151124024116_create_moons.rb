class CreateMoons < ActiveRecord::Migration
  def change
    create_table :moons do |t|
      t.belongs_to :planet, index: true
    end
  end
end
