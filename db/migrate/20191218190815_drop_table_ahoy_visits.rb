class DropTableAhoyVisits < ActiveRecord::Migration[5.2]
  def change
    drop_table :ahoy_visits
    drop_table :ahoy_events
  end
end
