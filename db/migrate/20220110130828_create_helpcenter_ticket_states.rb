class CreateHelpcenterTicketStates < ActiveRecord::Migration[5.2]
  def change
    create_table :helpcenter_ticket_states do |t|
      t.string :status
      t.timestamps
    end
  end
end
