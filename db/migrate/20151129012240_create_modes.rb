class CreateModes < ActiveRecord::Migration
  def change
    create_table :modes do |t|
      t.string  :name
      t.integer :value

      t.timestamps
    end
  end
end
