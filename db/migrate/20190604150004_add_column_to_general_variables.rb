class AddColumnToGeneralVariables < ActiveRecord::Migration[5.2]
  def change
    add_column :general_variables, :url, :string
  end
end
