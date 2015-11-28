class AddColumnsToSchedules < ActiveRecord::Migration
  def change
    add_column :schdules, :launch_time, :datetime
    add_column :schdules, :order, :string
  end
end
