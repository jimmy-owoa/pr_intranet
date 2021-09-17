class ChangeContentToGeneralMessages < ActiveRecord::Migration[5.2]
  def change
    change_column :general_messages, :content, :mediumtext
  end
end
