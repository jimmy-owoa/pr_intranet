class AddIntegrationCodeToGeneralMenus < ActiveRecord::Migration[5.2]
  def change
    add_column :general_menus, :integration_code, :string
  end
end
