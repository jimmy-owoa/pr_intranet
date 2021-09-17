class AddIsTransactionalToBenefits < ActiveRecord::Migration[5.2]
  def change
    add_column :general_benefits, :is_transactional, :boolean, default: false
  end
end