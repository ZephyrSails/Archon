class CreateResource < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string  :name
      t.integer :available
      t.integer :production
      t.integer :limit
      t.integer :den

      t.timestamps null: false
    end
  end
end
