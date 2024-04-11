class AddFieldsToHelpcenterTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :helpcenter_tickets, :character_of_process, :integer
    add_column :helpcenter_tickets, :recruitment_source, :integer
    add_column :helpcenter_tickets, :reason_for_search, :integer
    add_column :helpcenter_tickets, :number_of_vacancies, :integer
    add_column :helpcenter_tickets, :area, :integer
    add_column :helpcenter_tickets, :company, :integer
    add_column :helpcenter_tickets, :required_education, :integer
    add_column :helpcenter_tickets, :cost_center, :text
    add_column :helpcenter_tickets, :careers, :integer
    add_column :helpcenter_tickets, :years_of_experience, :integer
    add_column :helpcenter_tickets, :job_location, :integer
    add_column :helpcenter_tickets, :work_schedule, :integer
    add_column :helpcenter_tickets, :shift, :integer
    add_column :helpcenter_tickets, :observation, :text
    add_column :helpcenter_tickets, :admission_date, :date
    add_column :helpcenter_tickets, :income_composition, :integer
    add_column :helpcenter_tickets, :requires_account, :integer
    add_column :helpcenter_tickets, :requires_computer, :integer
    add_column :helpcenter_tickets, :request_date, :date
    add_column :helpcenter_tickets, :requested_position_title, :integer
    add_column :helpcenter_tickets, :replacement_user_id, :integer
  end
end

