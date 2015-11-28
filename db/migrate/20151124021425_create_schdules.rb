class CreateSchdules < ActiveRecord::Migration
  def change
    create_table :schdules do |t|
      t.belongs_to :empire, index: true
    end
  end
end
