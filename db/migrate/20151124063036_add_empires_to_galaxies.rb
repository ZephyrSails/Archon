class AddEmpiresToGalaxies < ActiveRecord::Migration
  def change
    add_reference :empires, :galaxy, index: true
    add_column :galaxies, :code, :string
  end
end
