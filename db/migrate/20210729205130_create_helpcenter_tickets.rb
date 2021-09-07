class CreateHelpcenterTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :helpcenter_tickets do |t|
      t.text :description
      t.string :status
      t.boolean :created_by_admin, default: false
      t.datetime :closed_at
      t.datetime :attended_at
      t.references :category
      t.references :user
      t.references :assistant

      t.timestamps
    end
  end
end
