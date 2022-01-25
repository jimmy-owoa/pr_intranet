class CreateHelpcenterTicketHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :helpcenter_ticket_histories do |t|
      t.references :user
      t.references :ticket
      t.references :ticket_state
      t.integer :supervisor_id
      t.timestamps
    end
  end
end
