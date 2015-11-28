class CreateEmpires < ActiveRecord::Migration
  def change
    create_table :empires do |t|
      t.string :email
      t.string :pass
      t.string :universe
      t.integer :rank
      t.integer :score
    end
  end
end
