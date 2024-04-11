class CreateHelpcenterJobApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :helpcenter_job_applications do |t|
      t.string :applicant_name
      t.string :email
      t.string :phone
      t.integer :application_status
      t.references :ticket

      t.timestamps
    end
  end
end
