class AddLabelToRole < ActiveRecord::Migration[5.2]
  def change
    add_column :roles, :label_name, :string, default: ''
  end
end
