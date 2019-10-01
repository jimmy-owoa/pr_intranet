class AddColumnsToGeneralUser < ActiveRecord::Migration[5.2]
  def change
    add_column :general_users, :gender, :string
    add_column :general_users, :position_classification, :string 
    add_column :general_users, :employee_classification, :string
    add_column :general_users, :syndicate_member, :string
    add_column :general_users, :rol, :string
    add_column :general_users, :civil_status, :string
    add_column :general_users, :contract_type, :string
    add_column :general_users, :schedule, :string
    add_column :general_users, :is_boss, :boolean
    add_column :general_users, :handicapped, :boolean
    add_column :general_users, :has_children, :boolean
    add_reference :general_users, :cost_center
    add_reference :general_users, :office
    add_reference :general_users, :management
  end
end