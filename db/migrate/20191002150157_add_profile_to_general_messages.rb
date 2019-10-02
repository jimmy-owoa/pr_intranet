class AddProfileToGeneralMessages < ActiveRecord::Migration[5.2]
  def change
    add_reference :general_messages, :profile
  end
end
